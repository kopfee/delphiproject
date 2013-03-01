// no convert
class CWnd
{
	int Create(struct SRect * r, int bcolor, int lcolor, int dcolor);
	void SetBColor(int color);
	void SetLColor(int color);
	void SetDColor(int color);
	virtual void ViewString(int x, int y, char * str, int fcolor, int bcolor, int rmargin = -1);
	virtual void pViewString(int x, int y, char * str, int fcolor, int bcolor, int rmargin = -1);
};


// convert => TKSForm
class CForm : public CWnd
{
	CForm::CForm(int x1, int y1, int x2, int y2, char * caption);
};

// convert => TKSButton
class CButton : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, char * caption, CForm * form);
};

// convert => TKSLabel + TKSEdit 
class CEdit : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, char * caption, CForm * form);
};

// convert => TKSLabel + TKSSwitchEdit
class CF2Edit : public CEdit
{
	void AddItem(char * caption, char * lstring, char * mask, int width, int status = 0);
	int Create(long id, int x1, int y1, int x2, int y2, CForm * form, int actkey = F2);
};

// convert => TKSLabel + TKSListEdit
class CListEdit : public CEdit
{
	void SetList(CListCheckBox * lsckbox, int actkey);
};

// convert => TKSLabel + TKSDateEdit
class CDateEdit : public CEdit
{
	int Create(long id, int x1, int y1, int x2, int y2, char * caption, CForm * form);
};

// convert => TKSCheckBox
class CCheckBox : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, char * caption, CForm * form);
};

// no convert 
class CListCheckBox : public CChildWnd
{
	int AddItem(char c, char * caption);
	virtual int Create(long id, int x1, int y1, int x2, int y2, CForm * form, int bkcolor = IDC_EDITDATA_BKCOLOR, int captioncolor = IDC_EDITDATA_FONTCOLOR);
};

// convert => TKSDBGrid
class CDBGrid : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, CForm * form, int ruller = 0);
	// convert => Column
	void AddField(char * caption, int width, int type, int dec, char * name = NULL, int sep = FALSE);
};

// convert => TKSMemo
class CText : public CChildWnd
{
	virtual int Create(long id, int x1, int y1, int x2, int y2, CForm * form, CBaseSet * dset, char * fieldname);
};

// convert => TKSDBMemo
class CDBText : public CText
{
};

// convert => TKSPanel
class CList : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, CForm * form, char * title, int color = IDC_LISTTITLE_FONTCOLOR);
	// convert => TKSLabel
	void AddField(int x, int y, char * caption, int captioncolor = IDC_LISTCAPTION_FONTCOLOR, int datacolor = IDC_LISTDATA_FONTCOLOR);
};

// convert => TKSLabel + TKSComboBox
class CComboBox : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, char * caption, CForm * form);
	void AddField(char * str, char hotkey);
};

// convert => TKSPanel
class CPanel : public CChildWnd
{
	int Create(long id, int x1, int y1, int x2, int y2, CForm * form, int font = 16);
	// convert => TKSLabel
	void ViewCaption(char * str, int x = -1, int y = -1, int color = -1, int font = -1);
};

// no convert
class CSeparate : public CChildWnd
{
public:
	int Create(long id, int x1, int y1, int x2, int y2, CForm * form);
};


