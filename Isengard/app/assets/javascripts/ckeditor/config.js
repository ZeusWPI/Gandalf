CKEDITOR.editorConfig = function( config )
{
  config.toolbar = 'Mini';

  config.toolbar_Mini =
    [
      ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
      ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
      ['NumberedList','BulletedList','-','Outdent','Indent'],
      ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
      ['Link','Unlink'],
      ['Image','Table','HorizontalRule'],
      ['Styles','Format','Font','FontSize'],
      ['TextColor','BGColor']
    ];
}
