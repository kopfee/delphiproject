#define MAMPACKAGESIZE 4*1024
#define PARMBITS 	256
#define BITSPERBYTE	8

	unsigned int 	RequestType;			// 交易编码，4字节
	unsigned char firstflag;				// 是否第一个请求（首包请求）
	unsigned char nextflag;				// 是否后续包请求
	unsigned int recCount;				// 本包的记录数
	unsigned int  retCode;				// 返回代码
	unsigned int  UserID;				// 请求者的ID号码
	ST_ADDR		  addr;			// 请求着的地址（6个子节）
	unsigned char ParmBits[PARMBITS/BITSPERBYTE];

	其中，重要的是RequestType和ParmBits域两个字段。

	包体结构如下：

typedef struct st_pack
{
	char			gddm[16];			// BIT 0  BYTE 0 股东代码
	char			ddbz[2];			// BIT 1  BYTE 0 市场标志
	char			nbbm[13];			// BIT 2  BYTE 0 内部编码
	char			card[26];			// BIT 3  BYTE 0 条码卡
	char			sfzh[51];			// BIT 4  BYTE 0 身份证
	char			gdxm[21];			// BIT 5  BYTE 0 股东姓名
	char			gpdm[11];			// BIT 6  BYTE 0 股票代码
	char			gpmc[21];			// BIT 7  BYTE 0 股票名称

	char			gydm[5];			// BIT 0  BYTE 1 柜员代码
	char			gydm2[5];			// BIT 1  BYTE 1 柜员代码2(复核柜员)
	double			wtjg;				// BIT 2  BYTE 1 委托价格
	double			cjjg;				// BIT 3  BYTE 1 成交价格
	long			wtsl;				  // BIT 4  BYTE 1 委托数量
	long			cjsl;				  // BIT 5  BYTE 1 成交数量
	char			wtlb[2];			// BIT 6  BYTE 1 委托类别
	char			lbmc[20];			// BIT 7  BYTE 1 委托类别(中文)

	char			lxdz[61];			// BIT 0  BYTE 2 联系地址
	char			lxdh[41];			// BIT 1  BYTE 2 联系电话
	int				yybid;				// BIT 2  BYTE 2 营业部编号
	int				yybid1;				// BIT 3  BYTE 2 营业部编号2(备用)
	char			htxh[7];			// BIT 4  BYTE 2 合同号码
	char			wtrq[15];			// BIT 5  BYTE 2 委托日期
	char			cjrq[15];			// BIT 6  BYTE 2 成交日期
	unsigned char	jymm[16];			// BIT 7  BYTE 2 交易密码

	unsigned char	zjmm[16];			// BIT 0  BYTE 3 资金密码
	unsigned char	czmm[16];			// BIT 1  BYTE 3 存折密码
	char			yhdm[5];			// BIT 2  BYTE 3 银行代码
	char			zhlb[2];			// BIT 3  BYTE 3 账户类别
	char			yhzh[41];			// BIT 4  BYTE 3 银行账号
	double			zzje;				// BIT 5  BYTE 3 转账金额
	char			zzlb[2];			// BIT 6  BYTE 3 转账类别
	double			kyje;				// BIT 7  BYTE 3 可用资金

	double			dqje;				// BIT 0  BYTE 4 当前资金
	double			zjfs;				// BIT 1  BYTE 4 资金发生
	double			wtdj;				// BIT 2  BYTE 4 委托冻结
	double			rgdj;				// BIT 3  BYTE 4 人工冻结
	double			qtdj;				// BIT 4  BYTE 4 其他冻结
	long			gpky;				  // BIT 5  BYTE 4 股票可用
	long			gpye;				  // BIT 6  BYTE 4 股票余额
	long			gpwtdj;				// BIT 7  BYTE 4 股票委托冻结
	
	long			gprgdj;				// BIT 0  BYTE 5 股票人工冻结
	char			fssj[11];			// BIT 1  BYTE 5 发生时间
	char			zy[4];				// BIT 2  BYTE 5 摘要
	char			zymc[21];			// BIT 3  BYTE 5 摘要名称
	char			gddm2[16];			// BIT 4  BYTE 5 股东代码
	char			ddbz2[2];			// BIT 5  BYTE 5 市场标志
	char			nbbm2[13];			// BIT 6  BYTE 5 内部编码
	char			card2[26];			// BIT 7  BYTE 5 条码卡
	
	char			sfzh2[41];			// BIT 0  BYTE 6 身份证
	char			gdxm2[21];			// BIT 1  BYTE 6 股东姓名
	unsigned char	lmess;				// BIT 2  BYTE 6 MESS 的长度
	char			mess[256];			// Bit 3 - 7 not used

	unsigned char	newmm[16];	// BIT 0  BYTE 7 新密码
	char			cxksrq[9];			// BIT 1  BYTE 7 查询开始日期
	char			cxjsrq[9];			// BIT 2  BYTE 7 查询结束日期
	int				khlb;				    // BIT 3  BYTE 7 客户类别
	char			wtfs[10];			  // BIT 4  BYTE 7 委托方式
	char			gdzt[2];			  // BIT 5  BYTE 7 股东状态
	char			szdm[10];			  // BIT 6  BYTE 7 深圳代码
	char			shdm[10];			  // BIT 7  BYTE 7 上海代码

	char			szbdm[10];			// BIT 0  BYTE 8 深圳B代码
	char			shbdm[10];			// BIT 1  BYTE 8 上海B代码
	char			othdm0[10];			// BIT 2  BYTE 8 第三方代码
	char			othdm1[10];			// BIT 3  BYTE 8 第四方代码
	char			othdm2[10];			// BIT 4  BYTE 8 第五方代码
	long			gpmrcj;				  // BIT 5  BYTE 8 股票买入成交
	char			email[31];			// BIT 6  BYTE 8 EMAIL地址
	char			email2[31];			// BIT 7 BYTE 8 EMAIL地址2

	long			bl1;				// BIT 0 BYTE 9 买1量
	long			bl2;				// BIT 1 BYTE 9 买2量
	long			bl3;				// BIT 2 BYTE 9 买3量;
	long			bl4;				// BIT 3 BYTE 9 买4量;
	long			sl1;				// BIT 4 BYTE 9 卖1量;
	long			sl2;				// BIT 5 BYTE 9 卖2量;
	long			sl3;				// BIT 6 BYTE 9 卖3量;
	long			sl4;				// BIT 7 BYTE 9 卖4量;

	double			bd1;				// BIT 0 BYTE 10 买1价;
	double			bd2;				// BIT 1 BYTE 10 买2价;
	double			bd3;				// BIT 2 BYTE 10 买3价;
	double			bd4;				// BIT 3 BYTE 10 买4价;
	double			sd1;				// BIT 4 BYTE 10 卖1价;
	double			sd2;				// BIT 5 BYTE 10 卖2价;
	double			sd3;				// BIT 6 BYTE 10 卖3价;
	double			sd4;				// BIT 7 BYTE 10 卖4价;
}ST_PACK;
