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

extern unsigned _stklen = 8192;

extern char SQLServerName[];
extern char SQLUserName[];
extern char SQLPassword[];
extern char SQLDatabase[];
extern char BMPPathName[];

// BEGIN:	0x12000100	IDM_柜台委托_委托/撤单
class CConvertDT : public CDataSet
{
public:
	virtual int GetFieldNumber(char * fieldname);
	virtual int GetFieldType(int fieldnum);
	virtual int GetFieldByNumber(int no, BYTE * data);
};

class fm1200WTCD : public CForm
{
	CDBGrid * dgWTCD;
	CConvertDT * dtWTCD;
	CComboBox * cmbSCXZ;
	CF2Edit * edKHH;
	CEdit * edWTXH;
	CEdit * edZQDM;
	CSeparate * sepWTCD;
	CButton * bnCDCX;
	CButton * bnCDQQ;
	CButton * bnTC;

public:
	fm1200WTCD(int x1, int y1, int x2, int y2, char * caption);
	~fm1200WTCD();
	virtual int OnDlgInitial();
	virtual int FirstFocus();
	virtual int OnExtraKeyDown(int key, long id);
	int CDCX();	// 撤单查询
	int CDQQ(); // 撤单请求
};

class fm1200WTMX : public CForm
{
	CDBGrid * dgWTMX;
	CConvertDT * dtWTMX;
	CF2Edit * edKHH;
	CEdit * edZQDM;
	CSeparate * sepWTMX;
	CButton * bnQR;
	CButton * bnTC;

public:
	fm1200WTMX(int x1, int y1, int x2, int y2, char * caption);
	~fm1200WTMX();
	virtual int OnDlgInitial();
	virtual int FirstFocus();
	virtual int OnExtraKeyDown(int key, long id);
};

class fm1200WT : public CForm
{
	long m_lKHH;		// 客户号
	char m_sSHZH[16];	// 上海帐号
	char m_sSZZH[16];	// 深圳帐号
	char m_sSCDM[2];	// 市场代码
	char m_sZQMC[21];	// 证券名称
	double m_dKMJE;		// 可买金额

	CList * lstKHXX;
	CList * lstJSHQ;
	CF2Edit * edKHH;
	CPanel * pnlWTXH;
	CEdit * edQYBWT;
	CEdit * edDM;
	CEdit * edJG;
	CEdit * edMM;
	CEdit * edSL;
	CPanel * pnlWTCK;
	CSeparate * sepWT;
	CButton * bnCD;
	CButton * bnCCJMX;
	CButton * bnTC;

public:
	fm1200WT(int x1, int y1, int x2, int y2, char * caption);
	~fm1200WT();
	void ViewBuy();
	void ViewSales();
	void ClearBuyAndSalse();
	virtual int OnDlgInitial();
	virtual int OnExtraKeyDown(int key, long id);
	virtual int OnSetFocus(long id);
	virtual int OnKillFocus(long id);
	int AfterInputKHH();
	int AfterInputZQDM();
	int AfterInputJG();
	int AfterInputSL();
};
// END:		0x12000100	IDM_柜台委托_委托/撤单

extern char SQLServerName[];
extern char SQLUserName[];
extern char SQLPassword[];
extern char SQLDatabase[];

void KeepSvrInitial();

// IDM_GYZD1_1_KHHKH: 0x11010100  客户号开户
int main()
{
	KeepSvrInitial();
	SystemInitial();
	LockCurrency(TRUE);

	fm1200WT * f1200WT = new(fm1200WT) (22, 80, 777, 512, "柜台委托_委托/撤单");
	f1200WT->DoModel();
	delete f1200WT;

	SafeExit();
	return 1;
}

// BEGIN:	0x12000100	IDM_柜台委托_委托/撤单
#define IDS_GRID_1200WTCD						0x12000101
#define IDS_COMBOX_1200WTCD_SCXZ				0x12000102
#define IDS_F2EDIT_1200WTCD_KHH                	0x12000103
#define IDS_EDIT_1200WTCD_WTXH                 	0x12000104
#define IDS_EDIT_1200WTCD_ZQDM                 	0x12000105
#define IDS_SEPARATE_1200WTCD					0x12000106
#define IDS_BUTTON_1200WTCD_CDCX               	0x12000107
#define IDS_BUTTON_1200WTCD_CDQQ               	0x12000108
#define IDS_BUTTON_1200WTCD_TC					0x12000109

int CConvertDT::GetFieldNumber(char * fieldname)
{
	if(strcmp(fieldname, "mmlbm") == 0) return 101;
	if(strcmp(fieldname, "wtztm") == 0) return 102;
	return CDataSet::GetFieldNumber(fieldname);
}

int CConvertDT::GetFieldType(int fieldnum)
{
	if(fieldnum == 101) return SQLCHAR;
	if(fieldnum == 102) return SQLCHAR;
	return CDataSet::GetFieldType(fieldnum);
}

int CConvertDT::GetFieldByNumber(int no, BYTE * data)
{
	char str[21];

	if(no == 101)
	{
		char sMMLB[2];
		CDataSet::GetFieldByName("mmlb", sMMLB);
		GetNoteWithString(1004, sMMLB, str);
		str[4] = 0;
		strcpy(data, str);
		return TRUE;
	}
	if(no == 102)
	{
		char sWTZT[2];
		CDataSet::GetFieldByName("wtzt", sWTZT);
		GetNoteWithString(1005, sWTZT, str);
		str[8] = 0;
		strcpy(data, str);
		return TRUE;
	}

	return CDataSet::GetFieldByNumber(no, data);
}

fm1200WTCD::fm1200WTCD(int x1, int y1, int x2, int y2, char * caption) : CForm(x1, y1, x2, y2, caption)
{
	dtWTCD = new (CConvertDT);
	dgWTCD = new (CDBGrid);
	dgWTCD->Create(IDS_GRID_1200WTCD, 12, 40, 747, 284, this, 2);
	dgWTCD->AddField("委托序号", 8, 'N', 0, "wtxh");
	dgWTCD->AddField("股东代码", 15, 'C', 0, "gddm");
	dgWTCD->AddField("客户姓名", conXM, 'C', 0, "xm");
	dgWTCD->AddField("买卖", 4, 'C', 0, "mmlbm");
	dgWTCD->AddField("证券代码", 8, 'C', 0, "zqdm");
	dgWTCD->AddField("委托价格", conJG, 'N', 3, "wtjg");
	dgWTCD->AddField("委托数量", conSL, 'N', 0, "wtsl");
	dgWTCD->AddField("成交数量", conSL, 'N', 0, "cjsl");
	dgWTCD->AddField("成交均价", conJG, 'N', 3, "cjjg");
	dgWTCD->AddField("撤单状态", 8, 'C', 0, "wtztm");
	dgWTCD->PutDataSet(dtWTCD);
	dgWTCD->SetFocusEnabled(TRUE);

	int iCurrency = GetCurrencyNumber();
	cmbSCXZ = new(CComboBox);
	cmbSCXZ->Create(IDS_COMBOX_1200WTCD_SCXZ, 22, 292, 180, 312, "市场选择", this);
	char sStr[31];
	char sBuffer[210];
	GetNoteSet(1010, sBuffer);
	if(iCurrency == 1)
	{
		sStr[0] =  ' '; sStr[1] = '1'; sStr[2] = '.'; sStr[3] = ' '; sStr[4] = 0;
		strcpy(&sStr[4], &sBuffer[21 * 0]);
		cmbSCXZ->AddField(sStr, '1');
		sStr[0] =  ' '; sStr[1] = '2'; sStr[2] = '.'; sStr[3] = ' '; sStr[4] = 0;
		strcpy(&sStr[4], &sBuffer[21 * 1]);
		cmbSCXZ->AddField(sStr, '2');
	}
	else if(iCurrency == 2)
	{
		sStr[0] =  ' '; sStr[1] = '1'; sStr[2] = '.'; sStr[3] = ' '; sStr[4] = 0;
		strcpy(&sStr[4], &sBuffer[21 * 2]);
		cmbSCXZ->AddField(sStr, '1');
	}
	else
	{
		sStr[0] =  ' '; sStr[1] = '1'; sStr[2] = '.'; sStr[3] = ' '; sStr[4] = 0;
		strcpy(&sStr[4], &sBuffer[21 * 3]);
		cmbSCXZ->AddField(sStr, '1');
	}
	cmbSCXZ->SetFocusEnabled(TRUE);

	edWTXH = new(CEdit);
	edWTXH->Create(IDS_EDIT_1200WTCD_WTXH, 200, 292, 360, 312, "委托序号", this);
	edWTXH->SetDataType(6, 'N', 0);
	edWTXH->SetFocusEnabled(TRUE);

	int iCount = GetAccountStyleCount();
	ACCOUNTSTYLE d;

	edKHH = new(CF2Edit);
	for(int i = 0; i < iCount; ++ i)
	{
		GetAccountStyleWithNumber(i, &d);
		if(AccountInCurrency(iCurrency, &d))
		{
			edKHH->AddItem(d.Name, d.HeadString, d.Mask, d.Width, d.Status);
		}
	}
	edKHH->Create(IDS_F2EDIT_1200WTCD_KHH, 380, 292, 560, 312, this);
	edKHH->SetFocusEnabled(TRUE);

	edZQDM = new(CEdit);
	edZQDM->Create(IDS_EDIT_1200WTCD_ZQDM, 580, 292, 740, 312, "证券代码", this);
	edZQDM->SetDataType(conZQDM, 'C', 0);
	edZQDM->SetFocusEnabled(TRUE);

	sepWTCD = new(CSeparate);
	sepWTCD->Create(IDS_SEPARATE_1200WTCD, 10, 322, 750, 326, this);

	bnCDCX = new(CButton);
	bnCDCX->Create(IDS_BUTTON_1200WTCD_CDCX, 112, 336, 224, 368, "撤单查询[^Q]", this);

	bnCDQQ = new(CButton);
	bnCDQQ->Create(IDS_BUTTON_1200WTCD_CDQQ, 324, 336, 436, 368, "撤单请求[F3]", this);

	bnTC = new(CButton);
	bnTC->Create(IDS_BUTTON_1200WTCD_TC, 536, 336, 648, 368, "  退    出  ", this);
}

fm1200WTCD::~fm1200WTCD()
{
	delete dgWTCD;
	delete dtWTCD;
	delete edKHH;
	delete cmbSCXZ;
	delete edZQDM;
	delete edWTXH;
	delete sepWTCD;
	delete bnCDCX;
	delete bnCDQQ;
	delete bnTC;
}

int fm1200WTCD::OnDlgInitial()
{
	if(dtWTCD->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dtWTCD->GetLastMessage(), (char *) 0);
		return FALSE;
	}

	if(dtWTCD->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dtWTCD->GetLastMessage(), (char *) 0);
		return FALSE;
	}

	return TRUE;
}

int fm1200WTCD::FirstFocus()
{
	ChildWndList[1]->SetFocus();
	return 1;
}

int fm1200WTCD::OnExtraKeyDown(int key, long id)
{
	int n;
	char str[81];

	if(key == Enter && id == IDS_BUTTON_1200WTCD_TC) return Esc;

	if(key == cmdQUERY)
	{
		PushKeyToKeyBuffer(Enter);
		n = GetCurrentChildWndNumber();
		if(n >= 6) return 6 - n;
		else return - (n + 3);
	}

	if(key == F3)
	{
		PushKeyToKeyBuffer(Enter);
		n = GetCurrentChildWndNumber();
		if(n >= 7) return 7 - n;
		else return - (n + 2);
	}

	if(key == Enter && id == IDS_BUTTON_1200WTCD_CDCX)
	{
		return CDCX();
	}

	if(key == Enter && id == IDS_BUTTON_1200WTCD_CDQQ)
	{
		return CDQQ();
	}

	return 0;
}

int fm1200WTCD::CDCX()
{
	char str[81];

	char cZHLB;				// 帐号类别
	char sZH[61];			// 帐号
	char sZQDM[7];			// 证券代码
	long lWTXH;				// 委托序号
	char sSCDM[4];			// 市场代码

	edKHH->GetResultName(str);
	cZHLB = GetAccountTypeWithName(Trim(str));
	edKHH->GetResultString(sZH);
	if(strcmp(Trim(sZH), "") == 0) strcpy(sZH, "*");
	strcpy(sZQDM, edZQDM->GetDataAsString());
	if(strcmp(sZQDM, "") == 0) strcpy(sZQDM, "*");
	lWTXH = floor(edWTXH->GetDataAsDouble());
	int iCurrency = GetCurrencyNumber();
	GetNoteSet(1010, str);
	if(iCurrency == 1)
	{
		if(cmbSCXZ->GetEditRow() == 0) strcpy(sSCDM, &str[4 * 0]);
		else strcpy(sSCDM, &str[4 * 1]);
	}
	else if(iCurrency == 2) strcpy(sSCDM, &str[4 * 2]);
	else strcpy(sSCDM, &str[4 * 3]);
	dtWTCD->Reset();
	dtWTCD->EnableRelation();
	dtWTCD->AddPROCParam((BYTE *) &cZHLB, SQLINT1, "@izhlb", INPUT);
	dtWTCD->AddPROCParam(sZH, SQLCHAR, "@izh", INPUT);
	dtWTCD->AddPROCParam(sZQDM, SQLCHAR, "@izqdm", INPUT);
	dtWTCD->AddPROCParam((BYTE *) &lWTXH, SQLINT4, "@iwtxh", INPUT);
	dtWTCD->AddPROCParam(sSCDM, SQLCHAR, "@iscdm", INPUT);
	if(dtWTCD->OpenBySP("jy_wtcx") == FAIL)
	{
		MessageBox("委托撤单查询出错：", dtWTCD->GetLastMessage(), (char *) 0);
		return -5;
	}
	return -6;
}

int fm1200WTCD::CDQQ()
{
	char str[81];

	CDataSet * dt = new(CDataSet);
	if(dt->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return -6;
	}

	if(dt->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return -6;
	}

	int iYYBH = GetDepartment();		// 营业部号
	char sSCDM[4];						// 市场代码
	long lWTXH;							// 委托序号
	int iCurrency = GetCurrencyNumber();
	int iCZYH = GetUserName();			// 操作员号
	lWTXH = floor(edWTXH->GetDataAsDouble());
	iCurrency = GetCurrencyNumber();
	GetValueSet(1010, str);
	if(iCurrency == 1)
	{
		if(cmbSCXZ->GetEditRow() == 0) strcpy(sSCDM, &str[4 * 0]);
		else strcpy(sSCDM, &str[4 * 1]);
	}
	else if(iCurrency == 2) strcpy(sSCDM, &str[4 * 2]);
	else strcpy(sSCDM, &str[4 * 3]);
	dt->AddPROCParam((BYTE *) &iYYBH, SQLINT2, "@iyybh", INPUT);
	dt->AddPROCParam(sSCDM, SQLCHAR, "@iscdm", INPUT);
	dt->AddPROCParam((BYTE *) &lWTXH, SQLINT4, "@iwtxh", INPUT);
	dt->AddPROCParam((BYTE *) &iCZYH, SQLINT2, "@iczyh", INPUT);

	if(dt->OpenBySP("jy_zhcd") == FAIL)
	{
		MessageBox("撤单请求出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return -6;
	}
	if(dt->GetRecordCount() == 0)
	{
		MessageBox("撤单请求出错：", "结果集没有记录！", (char *) 0);
		delete(dt);
		return -6;
	}
	long lERRMSG;
	dt->GetFieldByName("errmsg", (BYTE *) &lERRMSG);
	delete(dt);
	if(lERRMSG < 0)
	{
		ltoa(lERRMSG, str, 10);
		int n = strlen(str);
		str[n] = ':'; str[n + 1] = ' '; str[n + 2] = 0;
		GetErrorMessageInfo(lERRMSG, "jy_zhcd", &str[n + 2]);
		MessageBox("撤单请求出错：", str, (char *) 0);
		return -6;
	}
	MessageBox("撤单成功！", (char *) 0);
	edKHH->PutData("");
	edKHH->ClearData();
	return -6;
}

#define IDS_GRID_1200WTMX							0x12000111
#define IDS_F2EDIT_1200WTMX_KHH                     0x12000112
#define IDS_EDIT_1200WTMX_ZQDM						0x12000113
#define IDS_SEPARATE_1200WTMX						0x12000114
#define IDS_BUTTON_1200WTMX_QR						0x12000115
#define IDS_BUTTON_1200WTMX_TC						0x12000116

fm1200WTMX::fm1200WTMX(int x1, int y1, int x2, int y2, char * caption) : CForm(x1, y1, x2, y2, caption)
{
	dgWTMX = new(CDBGrid);
	dtWTMX = new(CConvertDT);
	dgWTMX->Create(IDS_GRID_1200WTMX, 12, 40, 747, 284, this, 8);
	dgWTMX->AddField("股东代码", conGDDM, 'C', 0, "gddm");
	dgWTMX->AddField("客户姓名", conXM, 'C', 0, "xm");
	dgWTMX->AddField("买卖", 4, 'C', 0, "mmlbm");
	dgWTMX->AddField("证券代码", 8, 'C', 0, "zqdm");
	dgWTMX->AddField("证券名称", 8, 'C', 0, "zqmc");
	dgWTMX->AddField("成交价格", conJG, 'N', 3, "cjjg");
	dgWTMX->AddField("成交数量", conSL, 'N', 0, "cjsl");
	dgWTMX->AddField("成交时间", conSHJ, 'N', 0, "cjsj");
	dgWTMX->AddField("申报时间", conSHJ+8, 'N', 0, "sbsj");
	dgWTMX->PutDataSet(dtWTMX);
	dgWTMX->SetFocusEnabled(TRUE);

	int i;
	int iCurrency = GetCurrencyNumber();
	int iCount = GetAccountStyleCount();
	ACCOUNTSTYLE d;
	edKHH = new(CF2Edit);
	for(i = 0; i < iCount; ++ i)
	{
		GetAccountStyleWithNumber(i, &d);
		if(AccountInCurrency(iCurrency, &d))
		{
			edKHH->AddItem(d.Name, d.HeadString, d.Mask, d.Width, d.Status);
		}
	}
	edKHH->Create(IDS_F2EDIT_1200WTMX_KHH, 22, 292, 220, 312, this);
	edKHH->SetFocusEnabled(TRUE);

	edZQDM = new(CEdit);
	edZQDM->Create(IDS_EDIT_1200WTMX_ZQDM, 240, 292, 440, 312, "证券代码", this);
	edZQDM->SetDataType(conZQDM, 'C', 0);
	edZQDM->SetFocusEnabled(TRUE);

	sepWTMX = new(CSeparate);
	sepWTMX->Create(IDS_SEPARATE_1200WTMX, 10, 322, 750, 326, this);

	bnQR = new(CButton);
	bnQR->Create(IDS_BUTTON_1200WTMX_QR, 150, 336, 262, 368, "  确    认  ", this);

	bnTC = new(CButton);
	bnTC->Create(IDS_BUTTON_1200WTMX_TC, 488, 336, 600, 368, "  退    出  ", this);
}

fm1200WTMX::~fm1200WTMX()
{
	delete dgWTMX;
	delete dtWTMX;
	delete edKHH;
	delete edZQDM;
	delete bnQR;
	delete bnTC;
	delete sepWTMX;
}

int fm1200WTMX::OnDlgInitial()
{
	if(dtWTMX->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dtWTMX->GetLastMessage(), (char *) 0);
		return FALSE;
	}

	if(dtWTMX->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dtWTMX->GetLastMessage(), (char *) 0);
		return FALSE;
	}

	return TRUE;
}

int fm1200WTMX::FirstFocus()
{
	ChildWndList[1]->SetFocus();
	return 1;
}

int fm1200WTMX::OnExtraKeyDown(int key, long id)
{
	int n;
	char str[81];
	if(key == Enter && id == IDS_BUTTON_1200WTMX_TC) return Esc;
	if(key == Ctrl_Enter)
	{
		PushKeyToKeyBuffer(Enter);
		n = GetCurrentChildWndNumber();
		if(n >= 4) return 4 - n;
		else return - (n + 2);
	}

	if(key == Enter && id == IDS_BUTTON_1200WTMX_QR)
	{
		char cZHLB;								// 帐号类别
		char sZH[61];							// 帐号
		edKHH->GetResultName(str);
		cZHLB = GetAccountTypeWithName(Trim(str));
		edKHH->GetResultString(sZH);
		char sZQDM[7];							// 证券代码
		strcpy(sZQDM, edZQDM->GetDataAsString());

		dtWTMX->Reset();
		dtWTMX->EnableRelation();
		dtWTMX->AddPROCParam((BYTE *) &cZHLB, SQLINT1, "@izhlb", INPUT);
		dtWTMX->AddPROCParam(sZH, SQLCHAR, "@izh", INPUT);
		dtWTMX->AddPROCParam(sZQDM, SQLCHAR, "@izqdm", INPUT);

		if(dtWTMX->OpenBySP("jy_cjmxcx") == FAIL)
		{
			MessageBox("成交明细查询出错：", dtWTMX->GetLastMessage(), (char *) 0);
			return -3;
		}

		if(dtWTMX->GetRecordCount() == 0)
		{
			MessageBox("成交明细查询：", "结果集没有记录！", (char *) 0);
			return -3;
		}

		return -3;
	}

	return 0;

}

#define IDS_LIST_1200WT_KHXX				   0x12000121
#define IDS_LIST_1200WT_JSHQ                   0x12000122
#define IDS_EDIT_1200WT_QYBWT                  0x12000123
#define IDS_PANEL_1200WT_WTXH                  0x12000124
#define IDS_F2EDIT_1200WT_KHH                  0x12000125
#define IDS_EDIT_1200WT_MM                     0x12000126
#define IDS_EDIT_1200WT_DM                     0x12000127
#define IDS_EDIT_1200WT_JG                     0x12000128
#define IDS_EDIT_1200WT_SL                     0x12000129
#define IDS_PANEL_1200WT_WTCK                  0x1200012a
#define IDS_SEPARATE_1200WT                    0x1200012b
#define IDS_BUTTON_1200WT_CD                   0x1200012c
#define IDS_BUTTON_1200WT_CCJMX                0x1200012d
#define IDS_BUTTON_1200WT_TC				   0x1200012e

fm1200WT::fm1200WT(int x1, int y1, int x2, int y2, char * caption) : CForm(x1, y1, x2, y2, caption)
{
	lstKHXX = new(CList);
	lstKHXX->Create(IDS_LIST_1200WT_KHXX, 12, 40, 360, 232, this, " 客户信息 ");
	lstKHXX->AddField(8, 24, "  客 户 号:");
	lstKHXX->AddField(8, 44, "  客户姓名:");
	lstKHXX->AddField(8, 64, "  客户证件:");
	lstKHXX->AddField(8, 84, "代理人姓名:");
	lstKHXX->AddField(8, 104, "代理人证件:");
	lstKHXX->AddField(8, 124, "代理人权限:");
	lstKHXX->AddField(8, 144, "  资金余额:");
	lstKHXX->AddField(8, 164, "  可用余额:");

	lstJSHQ = new(CList);
	lstJSHQ->Create(IDS_LIST_1200WT_JSHQ, 368, 40, 743, 232, this, " 即时行情 ");
	lstJSHQ->AddField(8, 24, "昨收盘价:");
	lstJSHQ->AddField(8, 44, "今开盘价:");
	lstJSHQ->AddField(8, 64, "股票名称:");
	lstJSHQ->AddField(8, 84, "成 交 量:");
	lstJSHQ->AddField(8, 104, "涨 停 价:");
	lstJSHQ->AddField(8, 124, "跌 停 价:");
	lstJSHQ->AddField(8, 144, "最 高 价:");
	lstJSHQ->AddField(8, 164, "最 低 价:");
	lstJSHQ->AddField(192, 24, "上证指数:");
	lstJSHQ->AddField(192, 44, "深圳指数:");
	lstJSHQ->AddField(224, 64, "卖三:");
	lstJSHQ->AddField(224, 84, "卖二:");
	lstJSHQ->AddField(224, 104, "卖一:");
	lstJSHQ->AddField(224, 124, "买一:");
	lstJSHQ->AddField(224, 144, "买二:");
	lstJSHQ->AddField(224, 164, "买三:");

	edQYBWT = new(CEdit);
	edQYBWT->Create(IDS_EDIT_1200WT_QYBWT,12, 240, 743, 260, "前一笔委托:", this);
	edQYBWT->SetBColor(IDC_PANEL_BKCOLOR);
	edQYBWT->SetFColor(IDC_PANEL_FONTCOLOR);
	edQYBWT->SetDataType(56, 'C', 0);

	pnlWTXH = new(CPanel);
	pnlWTXH->Create(IDS_PANEL_1200WT_WTXH, 12, 268, 743, 298, this, 24);

	int i;
	int iCurrency = GetCurrencyNumber();
	int iCount = GetAccountStyleCount();
	ACCOUNTSTYLE d;
	edKHH = new(CF2Edit);
	for(i = 0; i < iCount; ++ i)
	{
		GetAccountStyleWithNumber(i, &d);
		if(AccountInCurrency(iCurrency, &d))
		{
			edKHH->AddItem(d.Name, d.HeadString, d.Mask, d.Width, d.Status);
		}
	}
	edKHH->Create(IDS_F2EDIT_1200WT_KHH, 22, 306, 190, 326, this);
	edKHH->SetFocusEnabled(TRUE);

	edMM = new(CEdit);
	edMM->Create(IDS_EDIT_1200WT_MM, 210, 306, 286, 326, "1买2卖", this);
	edMM->SetDataType(1, 'N', 0);
	edMM->SetFocusEnabled(TRUE);

	edDM = new(CEdit);
	edDM->Create(IDS_EDIT_1200WT_DM, 306, 306, 416, 326, "代码", this);
	edDM->SetDataType(conZQDM, 'C', 0);
	edDM->SetFocusEnabled(TRUE);

	edJG = new(CEdit);
	edJG->Create(IDS_EDIT_1200WT_JG, 436, 306, 582, 326, "价格", this);
	edJG->SetDataType(conJG + 2, 'N', 3, TRUE);
	edJG->SetFocusEnabled(TRUE);

	edSL = new(CEdit);
	edSL->Create(IDS_EDIT_1200WT_SL, 602, 306, 731, 326, "数量", this);
	edSL->SetDataType(conSL, 'N', 0);
	edSL->SetFocusEnabled(TRUE);

	pnlWTCK = new(CPanel);
	pnlWTCK->Create(IDS_PANEL_1200WT_WTCK, 12, 334, 743, 364, this, 24);

	sepWT = new(CSeparate);
	sepWT->Create(IDS_SEPARATE_1200WT, 10, 374, 745, 378, this);

	bnCD = new(CButton);
	bnCD->Create(IDS_BUTTON_1200WT_CD, 100, 388, 236, 420, "查委托/撤单[F3]", this);

	bnCCJMX = new(CButton);
	bnCCJMX->Create(IDS_BUTTON_1200WT_CCJMX, 323, 388, 451, 420, "查成交明细[F7]", this);

	bnTC = new(CButton);
	bnTC->Create(IDS_BUTTON_1200WT_TC, 538, 388, 650, 420, "  退    出  ", this);
}

fm1200WT::~fm1200WT()
{
	delete lstKHXX;
	delete lstJSHQ;
	delete edKHH;
	delete edQYBWT;
	delete pnlWTXH;
	delete pnlWTCK;
	delete edMM;
	delete edJG;
	delete edDM;
	delete edSL;
	delete sepWT;
	delete bnCD;
	delete bnCCJMX;
	delete bnTC;
}

int fm1200WT::OnDlgInitial()
{
	return TRUE;
}

void fm1200WT::ViewSales()
{
	int n = strlen(BMPPathName);
	char * path = new (char [n + 10]);
	strcpy(path, BMPPathName);
	strcpy(&path[n], "sales.bmp");
	CBitmap * bmp = new (CBitmap);
	char * buffer = bmp->LoadBMP(path);
	BufferToScreen(290, 170, bmp->GetWidth(), bmp->GetHeight(), buffer);
	delete bmp;
	delete path;
}

void fm1200WT::ClearBuyAndSalse()
{
	Bar(290, 170, 60, 60, IDC_FORM_BKCOLOR);
}

void fm1200WT::ViewBuy()
{
	int n = strlen(BMPPathName);
	char * path = new (char [n + 8]);
	strcpy(path, BMPPathName);
	strcpy(&path[n], "buy.bmp");
	CBitmap * bmp = new (CBitmap);
	char * buffer = bmp->LoadBMP(path);
	BufferToScreen(290, 170, bmp->GetWidth(), bmp->GetHeight(), buffer);
	delete bmp;
	delete path;
}

int fm1200WT::OnExtraKeyDown(int key, long id)
{
	if(key == Enter && id == IDS_BUTTON_1200WT_TC) return Esc;
	if(key == Enter && id == IDS_BUTTON_1200WT_CD)
	{
		fm1200WTCD * f1200WTCD = new(fm1200WTCD) (20, 132, 779, 467, "委托_撤单/查委托");
		f1200WTCD->DoModel();
		delete f1200WTCD;
		return 0;
	}
	if(key == Enter && id == IDS_BUTTON_1200WT_CCJMX)
	{
		fm1200WTMX * f1200WTMX = new(fm1200WTMX) (20, 100, 779, 484, "委托_查成交明细");
		f1200WTMX->DoModel();
		delete f1200WTMX;
		return 0;
	}
	if(key == F3) // 撤单[F3]
	{
		KillFocusWithoutCheck();
		fm1200WTCD * f1200WTCD = new(fm1200WTCD) (20, 112, 779, 491, "手工委托_撤单委托");
		f1200WTCD->DoModel();
		delete f1200WTCD;
		SetFocus();
		return 0;
	}
	if(key == F7) // 查成交[F7]
	{
		KillFocusWithoutCheck();
		fm1200WTMX * f1200WTMX = new(fm1200WTMX) (20, 100, 779, 484, "委托_查成交明细");
		f1200WTMX->DoModel();
		delete f1200WTMX;
		SetFocus();
		return 0;
	}

	return 0;
}

int fm1200WT::OnSetFocus(long id)
{
	int result = TRUE;

	switch(id)
	{
	case IDS_F2EDIT_1200WT_KHH:
		lstKHXX->ClearData();
		lstJSHQ->ClearData();
		pnlWTXH->ClearData();
		pnlWTCK->ClearData();
		edMM->PutData("");
		edMM->PutData(0.0);
		edMM->ClearData();
		edJG->PutData("");
		edJG->PutData(0.0);
		edJG->ClearData();
		edDM->PutData("");
		edDM->ClearData();
		edSL->PutData("");
		edSL->PutData(0.0);
		edSL->ClearData();
		ClearBuyAndSalse();
		break;
	}

	return result;
}

int fm1200WT::OnKillFocus(long id)
{
	int result = 1;
	char str1[81], str2[51];

	switch(id)
	{
	case IDS_EDIT_1200WT_MM:
		if(edMM->GetDataAsDouble() == 1)
		{
			ViewBuy();
			pnlWTXH->ClearData();
			pnlWTCK->ClearData();
			result = 1;
			break;
		}
		if(edMM->GetDataAsDouble() == 2)
		{
			ViewSales();
			pnlWTXH->ClearData();
			pnlWTCK->ClearData();
			result = 1;
			break;
		}
		else
		{
			result = 0;
			break;
		}
	case IDS_F2EDIT_1200WT_KHH:
		result = AfterInputKHH();
		break;
	case IDS_EDIT_1200WT_DM:
		result = AfterInputZQDM();
		break;
	case IDS_EDIT_1200WT_JG:
		result = AfterInputJG();
		break;
	case IDS_EDIT_1200WT_SL:
		result = AfterInputSL();
		break;
	}

	return result;
}

int fm1200WT::AfterInputKHH()
{
	char str1[81], str2[51];

	strcpy(str1, edKHH->GetDataAsString());
	if(strcmp(Trim(str1), "") == 0)
	{
		MessageBox("该域不能为空！", (char *) 0);
		return 0;
	}

	CDataSet * dt = new(CDataSet);
	if(dt->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}

	int iCurrency = GetCurrencyNumber();
	char cZHLB;								// 帐号类别
	char sZH[61];							// 帐号
	edKHH->GetResultName(str1);
	cZHLB = GetAccountTypeWithName(Trim(str1));
	edKHH->GetResultString(sZH);
	char sHBDM[4];							// 货币代码
	sHBDM[0] = iCurrency | 0x30;
	sHBDM[1] = 0;

	dt->AddPROCParam((BYTE *) &cZHLB, SQLINT1, "@izhlb", INPUT);
	dt->AddPROCParam(sZH, SQLCHAR, "@izh", INPUT);
	dt->AddPROCParam(sHBDM, SQLCHAR, "@ihbdm", INPUT);
	if(dt->OpenBySP("com_cx_getkhxx") == FAIL)
	{
		MessageBox("客户信息查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->GetRecordCount() == 0)
	{
		MessageBox("客户信息查询：", "果集没有记录！", (char *) 0);
		delete(dt);
		return 0;
	}

	char sXM[9];		// 姓名
	char sZJBH[31];		// 证件编号
	char sDLXM[9];		// 代理姓名
	char sDLZJ[31];		// 代理证件
	char sDLQX[5];		// 代理权限
	double dZJYE;		// 资金余额
	dt->GetFieldByName("khh", (BYTE *) &m_lKHH);
	dt->GetFieldByName("shzh", m_sSHZH);
	Trim(m_sSHZH);
	dt->GetFieldByName("szzh", m_sSZZH);
	Trim(m_sSZZH);
	dt->GetFieldByName("xm", sXM);
	dt->GetFieldByName("zjbh", sZJBH);
	dt->GetFieldByName("dlxm", sDLXM);
	dt->GetFieldByName("dlzj", sDLZJ);
	dt->GetFieldByName("dlqx", sDLQX);
	dt->GetFieldByName("zjye", (BYTE *) &dZJYE);
	dt->GetFieldByName("kmje", (BYTE *) &m_dKMJE);
	delete dt;

	if(m_lKHH == 0) lstKHXX->PutDataItem(0, "", 0);
	else lstKHXX->PutDataItem(0, m_lKHH, 0);
	lstKHXX->PutDataItem(1, sXM, 0);
	lstKHXX->PutDataItem(2, sZJBH, 0);
	lstKHXX->PutDataItem(3, sDLXM, 0);
	lstKHXX->PutDataItem(4, sDLZJ, 0);
	lstKHXX->PutDataItem(5, sDLQX, 0);
	lstKHXX->PutDataItem(6, dZJYE, 14, 2);
	lstKHXX->PutDataItem(7, m_dKMJE, 14, 2);
	lstKHXX->ShowData();
	return 1;
}

int fm1200WT::AfterInputZQDM()
{
	char sZQDM[7];

	strcpy(sZQDM, edDM->GetDataAsString());
	Trim(sZQDM);
	if(strlen(sZQDM) != 4 && strlen(sZQDM) != 6)
	{
		MessageBox("错误证券代码！", (char *) 0);
		return 0;
	}

	if(strlen(sZQDM) == 6)
	{
		if(strlen(m_sSHZH) == 0)
		{
			MessageBox("上海帐号没有开户！", (char *) 0);
			return 0;
		}
		if(GetCurrencyNumber() != 1 && GetCurrencyNumber() != 2)
		{
			MessageBox("市场和币种不匹配！", (char *) 0);
			return 0;
		}
		if(GetCurrencyNumber() == 1) strcpy(m_sSCDM, "1"); // 人民币
		else strcpy(m_sSCDM, "3");	//美元
	}

	if(strlen(sZQDM) == 4)
	{
		if(strlen(m_sSZZH) == 0)
		{
			MessageBox("深圳帐号没有开户！", (char *) 0);
			return 0;
		}
		if(GetCurrencyNumber() != 1 && GetCurrencyNumber() != 3)
		{
			MessageBox("市场和币种不匹配！", (char *) 0);
			return 0;
		}
		if(GetCurrencyNumber() == 1) strcpy(m_sSCDM, "2"); // 人民币
		else strcpy(m_sSCDM, "4");	// 港币
	}

	CDataSet * dt = new(CDataSet);
	if(dt->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}

	dt->AddPROCParam(m_sSCDM, SQLCHAR, "@iscdm", INPUT);
	dt->AddPROCParam(sZQDM, SQLCHAR, "@izqdm", INPUT);
	if(dt->OpenBySP("jy_zhwt_hqcx") == FAIL)
	{
		MessageBox("行情查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->GetRecordCount() == 0)
	{
		MessageBox("行情查询：", "果集没有记录！", (char *) 0);
		delete(dt);
		return 0;
	}

	char sZSPJ[21];		// 昨收盘价
	char sJKPJ[21];		// 今开盘价
	char sCJL[21];		// 成交量
	char sZTJ[21];		// 涨停价
	char sDTJ[21];		// 跌停价
	char sZGJ[21];		// 最高价
	char sZDJ[21];		// 最低价
	char sSHZS[21];		// 上海指数
	char sSZZS[21];		// 深圳指数
	char sMCJ3[21];		// 卖出价3
	char sMCJ2[21];		// 卖出价2
	char sMCJ1[21];		// 卖出价1
	char sMRJ1[21];		// 买入价1
	char sMRJ2[21];		// 买入价2
	char sMRJ3[21];		// 买入价3

	dt->GetFieldByName("zspj", sZSPJ);
	dt->GetFieldByName("jkpj", sJKPJ);
	dt->GetFieldByName("zqmc", m_sZQMC);
	dt->GetFieldByName("cjl", sCJL);
	dt->GetFieldByName("upjg", sZTJ);
	dt->GetFieldByName("downjg", sDTJ);
	dt->GetFieldByName("zgj", sZGJ);
	dt->GetFieldByName("zdj", sZDJ);
	dt->GetFieldByName("shzs", sSHZS);
	dt->GetFieldByName("szzs", sSZZS);
	dt->GetFieldByName("mrj3", sMRJ3);
	dt->GetFieldByName("mrj2", sMRJ2);
	dt->GetFieldByName("mrj1", sMRJ1);
	dt->GetFieldByName("mcj1", sMCJ1);
	dt->GetFieldByName("mcj2", sMCJ2);
	dt->GetFieldByName("mcj3", sMCJ3);

	delete dt;

	lstJSHQ->PutDataItem(0, FillBlankAtEnd(Trim(sZSPJ), 12), 0);
	lstJSHQ->PutDataItem(1, FillBlankAtEnd(Trim(sJKPJ), 12), 0);
	lstJSHQ->PutDataItem(2, m_sZQMC, 0);
	lstJSHQ->PutDataItem(3, FillBlankAtEnd(Trim(sCJL), 12), 0);
	lstJSHQ->PutDataItem(4, FillBlankAtEnd(Trim(sZTJ), 12), 0);
	lstJSHQ->PutDataItem(5, FillBlankAtEnd(Trim(sDTJ), 12), 0);
	lstJSHQ->PutDataItem(6, FillBlankAtEnd(Trim(sZGJ), 12), 0);
	lstJSHQ->PutDataItem(7, FillBlankAtEnd(Trim(sZDJ), 12), 0);
	lstJSHQ->PutDataItem(8, FillBlankAtEnd(Trim(sSHZS), 12), 0);
	lstJSHQ->PutDataItem(9, FillBlankAtEnd(Trim(sSZZS), 12), 0);
	lstJSHQ->PutDataItem(10, FillBlankAtEnd(Trim(sMCJ3), 12), 0);
	lstJSHQ->PutDataItem(11, FillBlankAtEnd(Trim(sMCJ2), 12), 0);
	lstJSHQ->PutDataItem(12, FillBlankAtEnd(Trim(sMCJ1), 12), 0);
	lstJSHQ->PutDataItem(13, FillBlankAtEnd(Trim(sMRJ1), 12), 0);
	lstJSHQ->PutDataItem(14, FillBlankAtEnd(Trim(sMRJ2), 12), 0);
	lstJSHQ->PutDataItem(15, FillBlankAtEnd(Trim(sMRJ3), 12), 0);

	lstJSHQ->ShowData();

	return 1;
}

int fm1200WT::AfterInputJG()
{
	int n;
	char str[81], str2[51];

	CDataSet * dt = new(CDataSet);
	if(dt->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}

	char sBZ[2] = "0";					// 没有结果集
	char sWTFS[2] = "0";				// 柜台委托
	char sZQDM[7];
	strcpy(sZQDM, edDM->GetDataAsString());	// 证券代码
	char sMMLB[2];
	sMMLB[0] = (int) floor(edMM->GetDataAsDouble()) | 0x30;	// 买卖类别
	sMMLB[1] = 0;
	double dJG = edJG->GetDataAsDouble();	// 价格
	long lMAXSL;	// 最大数量
	long lERRMSG;	// 错误代码
	double dWTSXF;	// 委托手续费

	dt->AddPROCParam(sBZ, SQLCHAR, "@ibz", INPUT);
	if(strcmp(m_sSCDM, "1") == 0 || strcmp(m_sSCDM, "3") == 0)
		dt->AddPROCParam(m_sSHZH, SQLCHAR, "@igddm", INPUT);
	else dt->AddPROCParam(m_sSZZH, SQLCHAR, "@igddm", INPUT);
	dt->AddPROCParam((BYTE *) &m_lKHH, SQLINT4, "@ikhh", INPUT);
	dt->AddPROCParam(m_sSCDM, SQLCHAR, "@iscdm", INPUT);
	dt->AddPROCParam(sWTFS, SQLCHAR, "@iwtfs", INPUT);
	dt->AddPROCParam(sZQDM, SQLCHAR, "@izqdm", INPUT);
	dt->AddPROCParam(sMMLB, SQLCHAR, "@immlb", INPUT);
	dt->AddPROCParam((BYTE *) &dJG, SQLMONEY, "@ijg", INPUT);
	dt->AddPROCParam((BYTE *) &lMAXSL, SQLINT4, "@omaxsl", OUTPUT);
	dt->AddPROCParam((BYTE *) &lERRMSG, SQLINT4, "@oerrmsg", OUTPUT);
	dt->AddPROCParam((BYTE *) &dWTSXF, SQLMONEY, "@owtsxf", OUTPUT);
	if(dt->OpenBySP("jy_getwtmaxsl") == FAIL)
	{
		MessageBox("可委托数量查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(! dt->GetParameter("@omaxsl", (BYTE *) &lMAXSL))
	{
		MessageBox("可委托数量查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(! dt->GetParameter("@oerrmsg", (BYTE *) &lERRMSG))
	{
		MessageBox("可委托数量查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(! dt->GetParameter("@owtsxf", (BYTE *) &dWTSXF))
	{
		MessageBox("可委托数量查询出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}

	delete(dt);

	if(lERRMSG < 0)
	{
		ltoa(lERRMSG, str, 10);
		int n = strlen(str);
		str[n] = ':'; str[n + 1] = ' '; str[n + 2] = 0;
		GetErrorMessageInfo(lERRMSG, "jy_getwtmaxsl", &str[n + 2]);
		MessageBox("可委托数量查询出错：", str, (char *) 0);
		return 0;
	}

	if(floor(edMM->GetDataAsDouble()) == 1.0) strcpy(str2, "买入");
	else strcpy(str2, "卖出");
	if(strlen(Trim(edDM->GetDataAsString())) == 6)
	{
		sprintf(str, " %s %s %s %.3f 元", m_sSHZH, m_sZQMC, str2, edJG->GetDataAsDouble());
	}
	else
	{
		sprintf(str, " %s %s %s %.3f 元", m_sSZZH, m_sZQMC, str2, edJG->GetDataAsDouble());
	}
	pnlWTXH->ClearData();
	pnlWTXH->ViewCaption(str);
	if(floor(edMM->GetDataAsDouble()) == 1.0)
		sprintf(str, " 帐面资金最多可买：%ld 股。", lMAXSL);
	else
		sprintf(str, " 库存股票最多可卖：%ld 股。", lMAXSL);
	pnlWTCK->ClearData();
	pnlWTCK->ViewCaption(str);

	return 1;
}

int fm1200WT::AfterInputSL()
{
	char str[81], str2[51];

	if(floor(edSL->GetDataAsDouble()) == 0.0)
	{
		MessageBox("委托数量不能为零！", (char *) 0);
		return 0;
	}

	CDataSet * dt = new(CDataSet);
	if(dt->Connect(SQLUserName, SQLPassword, SQLServerName, 0) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->SetDataBase(SQLDatabase) == FAIL)
	{
		MessageBox(dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}

	char sWTFS[2] = "0";				// 柜台委托
	char sZQDM[7];
	strcpy(sZQDM, edDM->GetDataAsString());	// 证券代码
	char sMMLB[2];
	sMMLB[0] = (int) floor(edMM->GetDataAsDouble()) | 0x30;	// 买卖类别
	sMMLB[1] = 0;
	double dJG = edJG->GetDataAsDouble();	// 价格
	long lERRMSG;	// 错误代码

	long lSL = edSL->GetDataAsDouble();		// 委托数量
	char sWTBZ[2] = "0";			// 委托标志 (正常委托)
	char sYHDM[2] = " ";			// 银行代码
	char sWKDZ[13];					// 网卡地址
	strcpy(sWKDZ, GetNetAddr());
	int iCZYH = GetUserName();		// 操作员号
	int iYYBH = GetDepartment();
	dt->AddPROCParam((BYTE *) &iYYBH, SQLINT2, "@iyybh", INPUT);
	dt->AddPROCParam(m_sSCDM, SQLCHAR, "@iscdm", INPUT);
	dt->AddPROCParam(sWTFS, SQLCHAR, "@iwtfs", INPUT);
	if(strcmp(m_sSCDM, "1") == 0 || strcmp(m_sSCDM, "3") == 0)
		dt->AddPROCParam(m_sSHZH, SQLCHAR, "@igddm", INPUT);
	else dt->AddPROCParam(m_sSZZH, SQLCHAR, "@igddm", INPUT);
	dt->AddPROCParam((BYTE *) &m_lKHH, SQLINT4, "@ikhh", INPUT);
	dt->AddPROCParam(sZQDM, SQLCHAR, "@izqdm", INPUT);
	dt->AddPROCParam(sMMLB, SQLCHAR, "@immlb", INPUT);
	dt->AddPROCParam((BYTE *) &dJG, SQLMONEY, "@ijg", INPUT);
	dt->AddPROCParam((BYTE *) &lSL, SQLINT4, "@isl", INPUT);
	dt->AddPROCParam(sWTBZ, SQLCHAR, "@iwtbz", INPUT);
	dt->AddPROCParam(sYHDM, SQLCHAR, "@iyhdm", INPUT);
	dt->AddPROCParam(sWKDZ, SQLCHAR, "@iwkdz", INPUT);
	dt->AddPROCParam((BYTE *) &iCZYH, SQLINT2, "@iczyh", INPUT);
	if(dt->OpenBySP("jy_zhwt") == FAIL)
	{
		MessageBox("委托出错：", dt->GetLastMessage(), (char *) 0);
		delete(dt);
		return 0;
	}
	if(dt->GetRecordCount() == 0)
	{
		MessageBox("委托出错：", "结果集没有记录！", (char *) 0);
		delete(dt);
		return 0;
	}
	dt->GetFieldByName("errmsg", (BYTE *) &lERRMSG);
	long lWTXH;
	dt->GetFieldByName("wtxh", (BYTE *) &lWTXH);
	delete dt;

	if(lERRMSG < 0)
	{
		ltoa(lERRMSG, str, 10);
		int n = strlen(str);
		str[n] = ':'; str[n + 1] = ' '; str[n + 2] = 0;
		GetErrorMessageInfo(lERRMSG, "jy_zhwt", &str[n + 2]);
		MessageBox("委托出错：", str, (char *) 0);
		return 0;
	}

	sprintf(str, "委托序号：%ld", lWTXH);
	MessageBox("委托成功！", str, (char *) 0);

	if(floor(edMM->GetDataAsDouble()) == 1.0) strcpy(str2, "买入");
	else strcpy(str2, "卖出");
	if(strlen(Trim(edDM->GetDataAsString())) == 6)
	{
		sprintf(str, " %ld %s %s %s %.3f元 %ld股", lWTXH, m_sSHZH, m_sZQMC, str2, dJG, lSL);
	}
	else
	{
		sprintf(str, " %ld %s %s %s %.3f元 %ld股", lWTXH, m_sSZZH, m_sZQMC, str2, dJG, lSL);
	}
	edQYBWT->PutData(str);
	edQYBWT->ShowData();
	edKHH->PutData("");
    edKHH->ClearData();

	return -4;
}

// END:		0x12000100	IDM_柜台委托_委托/撤单
