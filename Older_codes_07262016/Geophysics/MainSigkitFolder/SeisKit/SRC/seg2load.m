function [trace_data,header] = seg2load (filename)

% SEG2LOAD Read a SEG-2 (standard SEG-2 format of the Society of Exploration Geophysicist)
%          file from disk.
%          [trace_data,headr]=seg2load ('filename') reads the file 'filename' and returns 
%          trace_data [m,n] containing n traces of m samples.
%          If no extension is given for the filename, the extension '.sg2' is assumed.
%          headr.rec contains common record informatin
%          headr.tr contains trace data informatin
%          
%          Modified  by Vilhelm, Charles University, Prague in october 2002
%          from original by Pièce PY 24/07/1996;LAMI - DeTeC Demining Technology Center;
%          Swiss Federal Institute of Technology (EPFL) - Lausanne, Switzerland


% check argument and filename
  if (nargin==0)
    error ('SEG2LOAD requires at least a filename as an argument !');
  end;

  if (isstr (filename)~=1)
    error ('Argument is not a filename !');
  end;

  if (isempty (findstr (filename,'.'))==1)
    filename =[filename,'.sg2'];
  end;

  fid=fopen (filename,'rb','ieee-le');
  if (fid ==-1)
    error (['Error opening ',filename,' for input !']);
  end;

% check for SEG-2 file type
% first 2 bytes equal '3a55h' (14933) for PC/Windows
  fileType=fread (fid,1,'short');
  if (fileType ~= 14933)
    fclose (fid);
    error ('Not a SEG-2 file !');
  end;

  nbOfSamples  =0;
  samplingInterval=0;
  timerFrequency  =0;
% read file descriptor block
  revNumber          = fread (fid,1,'short');
  sizeOfTracePointer = fread (fid,1,'ushort');
  nbOfTraces         = fread (fid,1,'ushort');
  sizeOfST           = fread (fid,1,'uchar');
  firstST            = fread (fid,1,'char');
  secondST           = fread (fid,1,'char');
  sizeOfLT           = fread (fid,1,'uchar');
  firstLT            = fread (fid,1,'char');
  secondLT           = fread (fid,1,'char');
  reserved           = fread (fid,18,'uchar');
  tracePointers      = fread (fid,nbOfTraces,'ulong');  

% read free strings 
  gen_const_rec='';
  fseek (fid,32+sizeOfTracePointer,'bof');
  offset = fread (fid,1,'ushort');
  while (offset > 0)
    freeString = setstr (fread (fid,offset-2,'char'))';
    if (findstr (freeString,'ACQUISITION_DATE') > 0)
      date_rec=(freeString (length ('ACQUISITION_DATE '):length (freeString)));
   end;
    if (findstr (freeString,'ACQUISITION_TIME') > 0)
      time_rec=(freeString (length ('ACQUISITION_TIME '):length (freeString)));
   end;
    if (findstr (freeString,'GENERAL_CONSTANT') > 0)
      gen_const_rec=(freeString (length ('GENERAL_CONSTANT '):length (freeString)));
   end;
     if (findstr (freeString,'COMPANY') > 0)
      comp_rec = (freeString (length ('COMPANY '):length (freeString)));
    end;
    if (findstr (freeString,'JOB_ID') > 0)
      job_rec = (freeString (length ('JOB_ID '):length (freeString)));
    end; 
    if (findstr (freeString,'OBSERVER') > 0)
      observ_rec = (freeString (length ('OBSERVER '):length (freeString)));
    end; 
    if (findstr (freeString,'TRACE_SORT') > 0)
      sort_rec = (freeString (length ('TRACE_SORT '):length (freeString)));
    end; 
    if (findstr (freeString,'UNITS') > 0)
      units_rec = (freeString (length ('UNITS '):length (freeString)));
    end; 
    if (findstr (freeString,'NOTE') > 0)
      note_rec = (freeString (length ('NOTE '):length (freeString)));
    end; 
    offset = fread (fid,1,'ushort');
  end;
%prepare header structure
header.rec.date_rec=date_rec;
header.rec.time_rec=time_rec;
header.rec.gen_const_rec=gen_const_rec;
header.rec.comp_rec=comp_rec;
header.rec.job_rec=job_rec;
header.rec.observ_rec=observ_rec;
header.rec.sort_rec=sort_rec;
header.rec.units_rec=units_rec;
header.rec.note_rec=note_rec;


% read traces
  channel(1:nbOfTraces)=0;
  delay(1:nbOfTraces)=0;
  desc(1:nbOfTraces)=0;
  receiver(1:nbOfTraces)=0;
  sampling(1:nbOfTraces)=0;
  skew(1:nbOfTraces)=0;
  source(1:nbOfTraces)=0;
  stack(1:nbOfTraces)=0;

  trace_data = zeros (1,nbOfTraces);
  for i=1:nbOfTraces,
    fseek (fid,tracePointers (i),'bof');
    traceId     = fread (fid,1,'ushort');
    sizeOfBlock = fread (fid,1,'ushort');
    sizeOfData  = fread (fid,1,'ulong');
    nbOfSamples = fread (fid,1,'ulong');
    dataCode    = fread (fid,1,'uchar');
    reserved    = fread (fid,19,'uchar');
    
    offset = fread (fid,1,'ushort');
  while (offset > 0)
    freeString = setstr (fread (fid,offset-2,'char'))';
    if (findstr (freeString,'CHANNEL_NUMBER') > 0)
      channel(i)=str2num(freeString (length ('CHANNEL_NUMBER '):length (freeString)));
   end;
    if (findstr (freeString,'DELAY') > 0)
      delay(i)=str2num(freeString (length ('DELAY '):length (freeString)));
   end;
   if (findstr (freeString,'DESCALING_FACTOR') > 0)
      desc(i)=str2num(freeString (length ('DESCALING_FACTOR '):length (freeString)));
   end;
   if (findstr (freeString,'FIXED_GAIN') > 0)
      gain=(freeString (length ('FIXED_GAIN '):length (freeString)));
   end;
   if (findstr (freeString,'RECEIVER_LOCATION') > 0)
      receiver(i)=str2num(freeString (length ('RECEIVER_LOCATION '):length (freeString)));
   end;
   if (findstr (freeString,'SAMPLE_INTERVAL') > 0)
      sampling(i)=str2num(freeString (length ('SAMPLE_INTERVAL '):length (freeString)));
   end;
   if (findstr (freeString,'SKEW') > 0)
      skew(i)=str2num(freeString (length ('SKEW '):length (freeString)));
   end;
   if (findstr (freeString,'SOURCE_LOCATION') > 0)
      source(i)=str2num(freeString (length ('SOURCE_LOCATION '):length (freeString)));
   end;
   if (findstr (freeString,'STACK') > 0)
      stack(i)=str2num(freeString (length ('STACK '):length (freeString)));
   end;
   if (findstr (freeString,'NOTE') > 0)
      note=str2num(freeString (length ('NOTE '):length (freeString)));
   end;
      
    offset = fread (fid,1,'ushort');
  end;
     
    fseek (fid,tracePointers (i),'bof');            %go to trace start
    freeString  = fread (fid,sizeOfBlock,'char');   %skip trace header
    trace_data (1:nbOfSamples,i)  = fread (fid,nbOfSamples,'float32');
end;
 
  fclose (fid);
    
    header.tr.channel=channel;
    header.tr.delay=delay;
    header.tr.desc=desc;
    header.tr.gain=gain;
    header.tr.receiver=receiver;
    header.tr.sampling=sampling;
    header.tr.skew=skew;
    header.tr.source=source;
    header.tr.stack=stack;
    header.tr.note=note;
    
% end of seg2load.m file