function ROIannotation295 = ImportT1T2Legacy(whatFilter)
%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/benfulcher/GoogleDrive/Work/CurrentProjects/CellTypesMouse/Code/Data/ROI_annotation_295.xlsx
%    Worksheet: QBI_annotation_apr15_lr copy.tx
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2017/07/26 22:46:41

if nargin < 1
    whatFilter = 'ABAcortex';
end

%===============================================================================

%% Import the data
fileNameROIs = 'ROI_annotation_295.xlsx';
[~, ~, raw] = xlsread(fileNameROIs);
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3,4]);
raw = raw(:,[1,5]);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
ROIannotation295 = table;

%% Allocate imported array to column variable names
ROIannotation295.id = data(:,1);
ROIannotation295.names = cellVectors(:,1);
ROIannotation295.acronym = cellVectors(:,2);
ROIannotation295.allen_group = cellVectors(:,3);
ROIannotation295.ROISize = data(:,2);

fprintf(1,'ROI info loaded from %s\n',fileNameROIs);

%-------------------------------------------------------------------------------
% Next get T1, T2 from Waxholm space
% ~~~OLD, NOT BIAS CORRECTED:
fid = fopen('T1_590_List.txt');
T1bias = textscan(fid,'%f');
fclose(fid);
fid = fopen('T2_590_List.txt');
T2bias = textscan(fid,'%f');
fclose(fid);
T1bias = T1bias{1};
T2bias = T2bias{1};

% ~~NEW, BIAS-CORRECTED:
fid = fopen('T1_Biascorrected.txt');
T1 = textscan(fid,'%f');
fclose(fid);
T1 = T1{1};
fid = fopen('T2_Biascorrected.txt');
T2 = textscan(fid,'%f');
fclose(fid);
T2 = T2{1};

%-------------------------------------------------------------------------------
% T1:T2 ratio from Valerio:
fid = fopen('T1-T2_Biascorr_QBI.txt');
T1T2 = textscan(fid,'%f');
fclose(fid);
T1T2 = T1T2{1};

%-------------------------------------------------------------------------------
% Mean Diffusivity (MD) data from Valerio's own scanner at ETH:
fid = fopen('MD_forBen.txt');
MD = textscan(fid,'%f');
fclose(fid);
MD = MD{1};

%-------------------------------------------------------------------------------
% Latest values from Valerio for 40-parcellation (13-6-2018)
% Valerio provided latest T1w:T2w values to this file:
% structInfoT1T2ABAcortex40 = ImportABA40();

%-------------------------------------------------------------------------------
% f = figure('color','w');
% plot(T1./T2,T1T2,'xk')
% xlabel('T1/T2 (manual)')
% ylabel('T1:T2 ratio data')


%-------------------------------------------------------------------------------
% Get ISOCORTEX:
isIsocortex = logical(ones(size(strcmp(ROIannotation295.allen_group,'ISOCORTEX')))); % Don't get isocortex
ROIannotation295 = ROIannotation295(isIsocortex,:);
ROIannotation295.acronym = cellfun(@(x)x(3:end),ROIannotation295.acronym,'UniformOutput',false);
ROIannotation295.T1bias = T1bias(ROIannotation295.id);
ROIannotation295.T2bias = T2bias(ROIannotation295.id);
ROIannotation295.T1T2bias = ROIannotation295.T1bias./ROIannotation295.T2bias;
ROIannotation295.T1 = T1(ROIannotation295.id);
ROIannotation295.T2 = T2(ROIannotation295.id);
ROIannotation295.T1T2_manual = ROIannotation295.T1./ROIannotation295.T2;
ROIannotation295.T1T2 = T1T2(ROIannotation295.id); % (latest bias-corrected values from Valerio)
ROIannotation295.MD = MD(ROIannotation295.id);

%-------------------------------------------------------------------------------
% Additional filter on structures:
%ROIannotation295 = StructureFilter(ROIannotation295,whatFilter);

% f = figure('color','w');
% plot(ROIannotation295.T1T2_manual,ROIannotation295.T1T2,'xk')
% title('Isocortex')

end
