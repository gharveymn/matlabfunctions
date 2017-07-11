function uTest_DateStr2Num(doSpeed)
% Automatic test: DateStr2Num
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% uTest_DateStr2Num(doSpeed)
% INPUT:
%   doSpeed: Optional logical flag to trigger time consuming speed tests.
%            Default: TRUE. If no speed test is defined, this is ignored.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, 7.13, WinXP/32, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2009-2014 matlab.THISYEAR(a)nMINUSsimon.de

% $JRev: R-m V:012 Sum:PMSed3lCPnju Date:24-Dec-2014 15:17:52 $
% $License: BSD $
% $File: Tools\UnitTests_\uTest_DateStr2Num.m $

% Initialize: ==================================================================
ErrID = ['JSimon:', mfilename];
if nargin == 0
   doSpeed = true;
end

% Number of random test data:
NRandTest = 10000;

% New formats for modern Matlab versions:
isMatlab7 = sscanf(version, '%f', 1) >= 7.0;

formatList = { ...
   0,    'dd-mmm-yyyy HH:MM:SS'; ...
   1,    'dd-mmm-yyyy'; ...
   29,   'yyyy-mm-dd'; ...
   30,   'yyyymmddTHHMMSS'; ...
   31,   'yyyy-mm-dd HH:MM:SS'; ...
   230,  'mm/dd/yyyyHH:MM:SS'; ...
   231,  'mm/dd/yyyy HH:MM:SS'; ...
   240,  'dd/mm/yyyyHH:MM:SS'; ...
   241,  'dd/mm/yyyy HH:MM:SS'; ...
   1000, 'dd-mmm-yyyy HH:MM:SS.FFF'; ...
   1030, 'yyyymmddTHHMMSS.FFF'; ...
   1031, 'yyyy-mm-dd,HH:MM:SS.FFF'};

% Do the work: =================================================================
% Hello:
disp(['==== Test DateStr2Num:  ', datestr(now, 0)]);
disp(['  File: ', which('DateStr2Num')]);

fprintf('\n== Check current date:\n');

formatNumber = [formatList{:, 1}];
formatString = formatList(:, 2);

% Known answer test for current date:
NowNum  = now;
NowTime = datenum(floor(datevec(NowNum)));  % Integer seconds!
NowDate = floor(NowNum);

N0    = DateStr2Num(datestr(NowTime, 0), 0);
N1    = DateStr2Num(datestr(NowTime, 1), 1);
N29   = DateStr2Num(datestr(NowTime, 29), 29);
N30   = DateStr2Num(datestr(NowTime, 30), 30);
N31   = DateStr2Num(datestr(NowTime, 31), 31);
N230  = DateStr2Num(datestr(NowTime, 31), 31);
N231  = DateStr2Num(datestr(NowTime, 31), 31);
N240  = DateStr2Num(datestr(NowTime, 31), 31);
N241  = DateStr2Num(datestr(NowTime, 31), 31);
N1000 = DateStr2Num([datestr(NowTime, 0),  '.123'], 1000);
N1030 = DateStr2Num([datestr(NowTime, 30), '.123'], 1030);
N1031 = DateStr2Num([datestr(NowTime, 31), '.123'], 1031);

if isequal(NowTime, N0) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(0) failed.']);
end
if isequal(NowDate, N1) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(1) failed.']);
end
if isequal(NowDate, N29) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(29) failed.']);
end
if isequal(NowTime, N30) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(30) failed.']);
end
if isequal(NowTime, N31) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(31) failed.']);
end
if isequal(NowTime, N230) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(230) failed.']);
end
if isequal(NowTime, N231) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(231) failed.']);
end
if isequal(NowTime, N240) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(240) failed.']);
end
if isequal(NowTime, N241) == 0
   error([ErrID, ':KAT'], ['*** ', mfilename, ': Format(241) failed.']);
end

if round(((NowTime - N1000) * 86400 + 0.123) * 1000) ~= 0
   error([ErrID, ':KAT'], ...
      ['*** ', mfilename, ': dd-mmm-yyyy HH:MM:SS.FFF format failed.']);
end
if round(((NowTime - N1030) * 86400 + 0.123) * 1000) ~= 0
   error([ErrID, ':KAT'], ...
      ['*** ', mfilename, ': yyyymmddTHHMMSS.FFF format failed.']);
end
if round(((NowTime - N1030) * 86400 + 0.123) * 1000) ~= 0
   error([ErrID, ':KAT'], ...
      ['*** ', mfilename, ': yyyy-mm-dd,HH:MM:SS.FFF format failed.']);
end

disp('  ok: 0, 1, 29, 30, 31, 230, 231, 240, 241, 1000, 1030, 1031 format');

% Test fractional seconds:
Date1000 = '21-Jan-2013 15:16:17.';
Date1030 = '20130121T151617.';
for f = 0:999
   fStr = sprintf('%03d', f);
   D    = DateStr2Num([Date1000, fStr], 1000);
   V    = datevec(D);
   f2   = rem(V(6), 1) * 1000;
   if abs(f - f2) > 0.01
      error([ErrID, ':KAT'], ...
         ['*** ', mfilename, ': Bad fractional seconds for [1000].']);
   end
   
   D    = DateStr2Num([Date1030, fStr], 1030);
   V    = datevec(D);
   f2   = rem(V(6), 1) * 1000;
   if abs(f - f2) > 0.01
      error([ErrID, ':KAT'], ...
         ['*** ', mfilename, ': Bad fractional seconds for [1030].']);
   end
end
fprintf('  ok: Fractional seconds for 1000 and 1030 format\n\n');

% ------------------------------------------------------------------------------
disp('== Random test data...');
drawnow;
minDateSec    = round(datenum('01-Jan-0000') * 86400);
maxDateSec    = round(datenum('31-Dec-9999') * 86400);
randDateSec   = round(minDateSec + rand(NRandTest, 1) * ...
   (maxDateSec - minDateSec));
randDateMySec = floor(rand(NRandTest, 1) * 1000);   % Micro-seconds

randDate    = randDateSec / 86400;
randDateMy  = (randDateSec * 1000 + randDateMySec) / 86400000;
randDateDay = floor(randDate);

fprintf('  ok: ');
hideMsg = {};                  % Tests beyond the power of Matlab 6
for index = 1:length(formatNumber)
   iFormat = formatNumber(index);
   if iFormat == 1 || iFormat == 29   % Without time:
      Want = randDateDay;
   elseif iFormat < 1000              % With time, integer seconds
      Want = randDate;
   else
      Want = randDateMy;              % With time, fractional seconds
   end
   
   if iFormat < 100
      StrPool = cellstr(datestr(Want, iFormat));
   elseif iFormat >= 1000
      StrPool = cellstr(datestr(randDate, iFormat - 1000));
      for iS = 1:numel(StrPool)
         StrPool{iS} = strcat(StrPool{iS}, sprintf('.%03d', randDateMySec(iS)));
      end
   elseif isMatlab7
      StrPool = cellstr(datestr(Want, formatString{index}));
   else  % Matlab 6 and format not supported by DATESTR:
      % It would be ridiculous to simulate a more powerful version of DATESTR
      % only to create test data. Therefore these tests are omitted:
      hideMsg{length(hideMsg) + 1} = formatString{index}; %#ok<AGROW>
      continue;
   end
   
   ConvC = DateStr2Num(StrPool, iFormat);
   ConvS = zeros(size(Want));
   for iP = 1:NRandTest
      ConvS(iP) = DateStr2Num(StrPool{iP}, iFormat);
   end
   
   if any(abs(Want - ConvS) * 86400 > 0.001)
      fprintf('\n');
      error([ErrID, ':RAND'], ['*** ', mfilename, ': Failed to convert: "', ...
         StrPool{iP}, '" to format ' sprintf('%d', iFormat)]);
   end
   if ~isequal(ConvS, ConvC)
      fprintf('\n');
      error([ErrID, ':RAND'], ['*** ', mfilename, ...
         ': Conversion differs for string an cell strings: "', char(10), ...
         StrPool{iP}, '" to format ' sprintf('%d', iFormat)]);
   end
   fprintf('%d, ', iFormat);
end
fprintf('\n');

if ~isempty(hideMsg)
   fprintf('::: Some formats are not tested under Matlab 6:\n');
   fprintf('    %s\n', hideMsg{:});
end

fprintf('  ok: Equal reply for string and cell methods\n\n');

% Speed: -----------------------------------------------------------------------
disp('== Speed tests...');

% Find a suiting number of loops:
C = datestr(floor(datevec(now)), 0);
if doSpeed
   iLoop     = 0;
   startTime = cputime;
   while cputime - startTime < 1.0
      v = datenum(C);     %#ok<NASGU>
      clear('v');
      iLoop = iLoop + 1;
   end
   nLoops = 100 * ceil(iLoop / ((cputime - startTime) * 50));
else
   disp('  Single loop => displayed times are not meaningful!');
   nLoops = 1;
end

fprintf('  Single string, %d loops on this machine.\n', nLoops);
fprintf([blanks(30), 'DATENUM  DateStr2Num\n']);
if isMatlab7
   knownFormat = formatNumber;
else  % Matlab 6:
   knownFormat = [0, 1];
end

for iFormat = knownFormat
   thisFormat = formatList{[formatList{:, 1}] == iFormat, 2};
   
   if iFormat <= 31
      C = datestr(floor(datevec(now)), iFormat);
   elseif isMatlab7
      C = datestr(now, thisFormat);
   else  % Matlab 6:
      tmpNow = now;
      tmp = round(mod(tmpNow * 86400, 1) * 1000);
      if iFormat == 1000
         C = [datestr(tmpNow, 0), sprintf('.%d', tmp)];
      else
         C = [datestr(tmpNow, 30), sprintf('.%d', tmp)];
      end
   end
   
   if isMatlab7
      tic;
      for i = 1:nLoops
         v = datenum(C, thisFormat);  %#ok<NASGU>
         clear('v');
      end
      tDatenum = toc + eps;
   else
      tic;
      for i = 1:nLoops
         v = datenum(C);  %#ok<NASGU>, no Format in Matlab 6
         clear('v');
      end
      tDatenum = toc + eps;
   end
   
   tic;
   for i = 1:nLoops * 10
      v = DateStr2Num(C, iFormat);  %#ok<NASGU>
      clear('v');
   end
   tNum = toc / 10;
   
   disp([sprintf('  %-26s', thisFormat), ...
      sprintf('  %-7.3f', tDatenum), '  ', sprintf('%-7.3g', tNum), ...
      '     => ', sprintf('%.2f', 100 * tNum / tDatenum), '%']);
end

% Speed tests fpr cells: -------------------------------------------------------
fprintf('\n');
if doSpeed
   nDate = 10000;
else
   nDate = 1000;
end

% Find a suiting number of loops:
if doSpeed
   nowValue = now;
   C = cell(nDate, 1);
   for iC = 1:nDate
      C{iC, 1} = datestr(nowValue, 0);
   end

   iLoop      = 0;
   startTime  = cputime;
   thisFormat = formatList{[formatList{:, 1}] == 0, 2};
   while cputime - startTime < 1.0
      v = datenum(C, thisFormat);     %#ok<NASGU>
      clear('v');
      iLoop = iLoop + 1;
   end
   nLoops = max(2, ceil(iLoop / (cputime - startTime)));
else
   disp('  Single loop => displayed times are not meaningful!');
   nLoops = 2;
end

% Show what is tested:
fprintf('  {1 x %d} cell string, %d loops on this machine.\n', nDate, nLoops);
fprintf([blanks(30), 'DATENUM  DateStr2Num\n']);
if isMatlab7
   knownFormat = formatNumber;
else
   knownFormat = 0;
end

% Run the tests for cell strings:
C = cell(nDate, 1);
for k = knownFormat
   index = find(formatNumber == k);
   
   iFormat    = formatNumber(index);
   thisFormat = formatString{index};
   
   nowValue  = now;
   nowVector = datevec(nowValue);
   for iC = 1:nDate
      if iFormat <= 31
         C{iC} = datestr(nowValue, iFormat);
      elseif isMatlab7
         C{iC} = datestr(nowValue, thisFormat);
      else  % Matlab 6:
         switch iFormat
            case 230  % 'mm/dd/yyyyHH:MM:SS'
               C{iC} = sprintf('%.2d/%.2d/%.4d%.2d:%.2d:%.2d', ...
                  nowVector([2,3,1,4,5,6]));
            case 231  % 'mm/dd/yyyy HH:MM:SS'
               C{iC} = sprintf('%.2d/%.2d/%.4d %.2d:%.2d:%.2d',  ...
                  nowVector([2,3,1,4,5,6]));
            case 240  % 'dd/mm/yyyyHH:MM:SS'
               C{iC} = sprintf('%.2d/%.2d/%.4d%.2d:%.2d:%.2d',  ...
                  nowVector([3,2,1,4,5,6]));
            case 241  % 'dd/mm/yyyy HH:MM:SS'
               C{iC} = sprintf('%.2d/%.2d/%.4d %.2d:%.2d:%.2d',  ...
                  nowVector([3,2,1,4,5,6]));
            case 1000
               tmp   = round(mod(nowValue * 86400, 1) * 1000);
               C{iC} = [datestr(nowValue, 0), sprintf('.%d', tmp)];
            case 1030
               tmp   = round(mod(nowValue * 86400, 1) * 1000);
               C{iC} = [datestr(nowValue, 30), sprintf('.%d', tmp)];
            otherwise
               error([ErrID, ':SPEED'], ['*** ', mfilename, ...
                  ': Unknown format']);
         end
      end
   end
   
   if isMatlab7
      tic;
      for i = 1:nLoops
         v = datenum(C, thisFormat);  %#ok<NASGU>
         clear('v');
      end
      tDatenum = toc + eps;
   else
      tic;
      for i = 1:nLoops
         v = datenum(C);  %#ok<NASGU>, no Format in Matlab 6
         clear('v');
      end
      tDatenum = toc + eps;
   end
   
   tic;
   for i = 1:nLoops * 10   % Increase precision
      v = DateStr2Num(C, iFormat);  %#ok<NASGU>
      clear('v');
   end
   tNum = toc / 10;
   
   disp([sprintf('  %-26s', thisFormat), ...
      '  ', sprintf('%-7.3f', tDatenum), ...
      '  ', sprintf('%-7.3g', tNum), ...
      '     => ', sprintf('%.2f', 100 * tNum / tDatenum), '%']);
end

% Goodbye:
disp([char(10), 'DateStr2Num passed the tests.']);

% return;
