function MapToMaster(fname) {
  var map={};
  // <Key> Source file is set to file https://docs.google.com/spreadsheets/d/<Value>/edit#gid=0
  // Replace <Value> from the values below to generate a link to the Master file that can be pasted in the browser to open it.
  map["testSource1"]="1mvTG9PhFNWdGsd4_8xv2MynurDq-L2-9Feh6vmTOdLs";
  map["testSource2"]="1HYer-22CoQe0CFXgkXhKSMyZG6eAjwbbr3HcMYJXMnk";
  return map[fname]
}

function GetDateTime () {
  var d = new Date();
  var curr_date = d.getDate();
  var curr_month = d.getMonth() + 1; //Months are zero based
  var curr_year = d.getFullYear();
  var curr_hour=d.getHours();
  var curr_min=d.getMinutes();
  var Stamp = curr_year + "-" +curr_month + "-" + curr_date + "-" + curr_hour + "-" + curr_min;
  return Stamp
}

function ArchiveFile(SourceFileId, TargetFolderId) {
  var file = DriveApp.getFileById(SourceFileId);
  file.getParents().next().removeFile(file);
  DriveApp.getFolderById(TargetFolderId).addFile(file);
  var DateStamp=GetDateTime();
  var newfile = file + "-" + DateStamp;
  file.setName(newfile);
  
}

function GetData() {
  //declare multiple variables in one statement - Initial value will
  //be undefined
  var SearchFolderID,ArchiveFolderID,files,file,filename,fileID,
      infile1,outfile1,infile2,outfile2,
      Master_ID,MasterSheet,MasterRange,
      SourceSheet,SourceRange,SourceValues;
  
  // Folder where the script looks for Source sheets to update from
  SearchFolderID="1XzWqOM7PmPuWBrucgwlbDIk9zEemFayc";
  ArchiveFolderID="1obngCNyRbpk7Ts6hSje6_m6Sf93T199N";
  files = DriveApp.getFolderById(SearchFolderID).getFiles();
  
  while (files.hasNext()) {
    file = files.next();
    if (file.getMimeType() !== "application/vnd.google-apps.spreadsheet") {
      continue;
    }

    fileID = file.getId();
    filename = file.getName();

    // if (file == infile1){ Master_ID = outfile1; }
    // else if (file == infile2){ Master_ID = outfile2; }
    Master_ID = MapToMaster(filename);
    SourceSheet = SpreadsheetApp.openById(file.getId()).getSheetByName("Sheet1");
    // getRange arguments syntax: start row, start column, numRows, number of Columns
    SourceRange = SourceSheet.getRange(2,1,SourceSheet.getLastRow()-1,6);
    SourceValues = SourceRange.getValues();

    // Append all data from the new Source files to the appropriate Master file
    MasterSheet = SpreadsheetApp.openById(Master_ID).getSheetByName('Sheet1');
    // Logger.log(DateStamp);
    // temprange = MasterSheet.getRange(1,1,1,1)
    // temprange.setValue(DateStamp);
    // temprange = MasterSheet.getRange(1,2,1,1)
    // temprange.setValue(filename);
    MasterRange = MasterSheet
        .getRange(MasterSheet.getLastRow()+1,1,SourceValues.length,SourceValues[0].length);
    MasterRange.setValues(SourceValues); 
    ArchiveFile(fileID,ArchiveFolderID);
  }
}
