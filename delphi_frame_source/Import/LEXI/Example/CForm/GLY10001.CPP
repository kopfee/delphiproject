#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <alloc.h>
#include "SysInit.h"
#include "keep.h"
#include "input.h"
#include "Compon.h"
#include "model.h"
#include "Id.h"

/***************************************************************************
  BEGIN: 0x41000100 系统维护_系统初始化
***************************************************************************/
class fm4100XTCSH : public CForm
{
	CPanel * pnlXD;
	CDateEdit * edCSHRQ;
	CSeparate * sepXTCSH;
	CButton * bnKSCSH;
	CButton * bnTC;

public:
	fm4100XTCSH(int x1, int y1, int x2, int y2, char * caption);
	~fm4100XTCSH();
	virtual int OnDlgInitial();
	virtual int OnExtraKeyDown(int key, long id);
	int doinit();
};
//  END: 0x41000100 系统维护_系统初始化

extern unsigned _stklen = 8192;
extern char SQLServerName[];
extern char SQLUserName[];
extern char SQLPassword[];
extern char SQLDatabase[];

void KeepSvrInitial();

int main()
{
	KeepSvrInitial();
	SystemInitial();
	LockCurrency(TRUE);

	fm4100XTCSH * f = new(fm4100XTCSH) (110, 150, 689, 434, "管理员终端_系统维护_系统初始化");
	f->DoModel();
	delete f;

	SafeExit();
	return 1;
}

/***************************************************************************
  BEGIN: 0x41000100 系统维护_系统初始化
***************************************************************************/
#define IDS_PANEL_4100XTCSH_XD						0x41000101
#define IDS_EDIT_4100XTCSH_CSHRQ					0x41000102
#define IDS_SEPARATE_4100XTCSH                      0x41000103
#define IDS_BUTTON_4100XTCSH_KSCSH                  0x41000104
#define IDS_BUTTON_4100XTCSH_TC                     0x41000105

fm4100XTCSH::fm4100XTCSH(int x1, int y1, int x2, int y2, char * caption) : CForm(x1, y1, x2, y2, caption)
{
	pnlXD = new(CPanel);
	pnlXD->Create(IDS_PANEL_4100XTCSH_XD, 50, 60, 555, 184, this, 16);
	pnlXD->SetBColor(IDC_FORM_BKCOLOR);
	pnlXD->SetLColor(IDC_FORM_BKCOLOR);
	pnlXD->SetDColor(IDC_FORM_BKCOLOR);

	edCSHRQ = new(CDateEdit);
	edCSHRQ->Create(IDS_EDIT_4100XTCSH_CSHRQ, 22, 192, 220, 212, "初始化日期", this);
	edCSHRQ->SetFocusEnabled(TRUE);

	sepXTCSH = new(CSeparate);
	sepXTCSH->Create(IDS_SEPARATE_4100XTCSH, 10, 222, 570, 226, this);

	bnKSCSH = new(CButton);
	bnKSCSH->Create(IDS_BUTTON_4100XTCSH_KSCSH, 78, 236, 174, 268, "开始初始化", this);

	bnTC = new(CButton);
	bnTC->Create(IDS_BUTTON_4100XTCSH_TC, 380, 236, 492, 268, "  退    出  ", this);

}

fm4100XTCSH::~fm4100XTCSH()
{
	delete pnlXD;
	delete edCSHRQ;
	delete sepXTCSH;
	delete bnKSCSH;
	delete bnTC;

}

int fm4100XTCSH::OnDlgInitial()
{
	pnlXD->ViewCaption("系统初始化完成工作如下:", 1, 1);
	pnlXD->ViewCaption("    1.当日数据表准备;", 1, 25);
	pnlXD->ViewCaption("    2.当日购回预处理;", 1, 49);
	pnlXD->ViewCaption("    3.隔日委托处理;", 1, 73);
	pnlXD->ViewCaption("提醒:进行该操作时禁止其它用户登录.", 1, 97);
	return TRUE;
}

int fm4100XTCSH::OnExtraKeyDown(int key, long id)
{
	if (key == Enter)
		if (id == IDS_BUTTON_4100XTCSH_TC)
			return Esc;
	if (key == cmdOK)
	{
		if (doinit())
		{
			MessageBox("系统初始化完毕", (char *) 0);
			return Esc;
		}
		else
		{
			int no = GetCurrentChildWndNumber();
			if (no == 1)
				return 0;
			if (no == 1)
				return -1;
			if (no == 2)
				return -2;
		}
	}
	if (key == Enter)
		if (id == IDS_BUTTON_4100XTCSH_KSCSH)
		{
			if (doinit())
				return Esc;
			else
				return -1;
		}
	return 0;

}

int fm4100XTCSH::doinit()
{
	int iYYBH, iCZYH;
	long lRQ;
	lRQ = long (edCSHRQ->GetDataAsDouble());
	iYYBH = GetDepartment();
	iCZYH = GetUserName();
	CRecordSet * dtCSH = new(CRecordSet);
	if (dtCSH->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dtCSH->GetLastMessage(), (char *) 0);
		delete dtCSH;
		return FALSE;
	}

	if (dtCSH->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dtCSH->GetLastMessage(), (char *) 0);
		delete dtCSH;
		return FALSE;
	}

	dtCSH->AddPROCParam((BYTE *) &iYYBH, SQLINT2, "@iyybh", INPUT);
	dtCSH->AddPROCParam((BYTE *) &iCZYH, SQLINT2, "@iczyh", INPUT);
	dtCSH->AddPROCParam((BYTE *) &lRQ, SQLINT4, "@irq", INPUT);
	if (dtCSH->OpenBySP("xtwh_xtinit") == FAIL)
	{
		MessageBox(dtCSH->GetLastMessage(), (char *) 0);
		delete dtCSH;
		return FALSE;
	}


	char str[81];
	long lERRMSG;
	char m_sMemoNo[16];
	dtCSH->GetFieldByName("errmsg", (BYTE *) &lERRMSG);
	if(lERRMSG < 0)
	{
		sprintf(str, "%10ld: ", lERRMSG);
		GetErrorMessageInfo(lERRMSG, "xtwh_dbyh", &str[12]);
		MessageBox("系统初始化出错", str, (char *) 0);
		delete(dtCSH);
		return 0;
	}
	else
	{
	MessageBox("系统初始化完毕", (char *) 0);
	delete dtCSH;
	return TRUE;
	}

}
//  END: 0x41000100 系统维护_系统初始化
