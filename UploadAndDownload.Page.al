page 25028499 "Upload and Download files"
{
    ApplicationArea = All;
    Caption = 'Test Page';
    PageType = List;
    SourceTable = "Test Table";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File"; Rec."Blob File")
                {
                    ToolTip = 'Specifies the value of the File field.', Comment = '%';
                }
                field(Name; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Upload) //Загрузка файла в Блоб
            {
                ApplicationArea = All;
                Caption = 'Upload';
                Promoted = true;
                PromotedCategory = Process;
                Image = Upload;
                trigger OnAction()
                var
                    FileName: Text;
                    InStr: InStream;
                    OutStr: OutStream;
                begin
                    Rec."Blob File".CreateInStream(InStr); //Создаем поток для чтения
                    UploadIntoStream('Upload a file', '', '', FileName, InStr); //Загружаем файл в поток
                    if FileName <> '' then begin //Если имя файла не пустое
                        Rec."File Name" := FileName; //Записываем имя файла
                        Rec."Blob File".CreateOutStream(OutStr); //Создаем поток для записи
                        CopyStream(OutStr, InStr); //Копируем поток
                        Rec.Insert(); //Вставляем запись
                    end;
                end;
            }
            action(Download) //Скачивание файла из Блоб
            {
                ApplicationArea = All;
                Caption = 'Download';
                Promoted = true;
                PromotedCategory = Process;
                Image = Download;
                trigger OnAction()
                var
                    InStr: InStream;
                    FileName: Text;
                begin
                    FileName := Rec."File Name"; //Получаем имя файла
                    if FileName <> '' then Begin
                        Rec."Blob File".CreateInStream(InStr); //Создаем поток для чтения
                        DownloadFromStream(InStr, 'Download a file', '', '', FileName);     //Скачиваем файл из потока
                    end;
                end;
            }

        }
    }
}