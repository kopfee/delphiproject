use ZTSP
if exists(select * from sysobjects where id=object_id('dbo.jy_cjsszh') and  (0xf & sysstat= 4) )
	drop proc dbo.jy_cjsszh
GO
/*
TODO:
	日期/时间 char=>int 的转换
	转托管,配股,转股,回售的处理
	指定交易的处理
*/
create proc dbo.jy_cjsszh 
	@iyybdm char(8),	/*营业部代码*/
	@iscdm char(1),		/*市场代码*/
	@igddm char(15),	/*股东代码*/
	@icjrq char(8),		/*成交日期*/
	@icjbh char(12),	/*成交编号*/
	@ixwdm char(8), 	/*席位代码*/
	@iscye int, 		/*上次余额*/
	@icjsl int,		/*成交数量*/
	@ibcye int,		/*本次余额*/
	@izqdm char(8),		/*证券代码*/
	@isbsj char(8),		/*申报时间*/
	@icjsj char(8),		/*成交时间*/
	@icjjg money,		/*成交价格*/
	@icjje money,		/*成交金额*/
	@ihth char(10),		/*合同号*/
	@ijgrq char(8),		/*交割日期*/
	@ibs char(1),		/*买卖标志 1 买 2 卖 */  
	@ibz char(3),		/**/
	@izgdm char(3)		/**/
as
begin
 -- 声明来自委托回报库的数据  	
  declare @_wtxh int,  	@_scdm char(1),	@_sbry smallint ,@_sbsj int ,@_sbxh char(10) ,
  	@_cjsl int, 	@_zhsl int,  	@_cjjg money,  	@_cjje money,  	@_yxrq int ,
  	@_xwdm char(8) ,@_rq int ,  	@_cdsqsj int , 	@_cdcgsj int , 	@_cdqqry smallint ,
  	@_cdry smallint ,@_wtzt char(1) ,@_err char(6) ,@_cjsj int ,  	@_wtsl int ,
  	@_cjbs int ,  	@_fy1 money ,  	@_fy2 money ,  	@_khh int ,  	@_sbdm char(15) ,
  	@_gddm char(15) ,@_zqdm char(6) ,@_mmlb char(1) ,@_wtjg money ,	@_djje money
  -- 声明委托回报库的新(修改以后的)数据   	    	
  declare @new_cjsl int, @new_cjjg money,@new_cjje money,@new_cdcgsj int ,
  	@new_wtzt char(1) ,@new_err char(6) ,@new_cjsj int ,@new_wtsl int ,
  	@new_cjbs int , @new_fy1 money , @new_fy2 money 
  declare @cllr int /* 处理方式 1 成交 2 撤单 3 其他 4 错误*/
  -- 声明来自证券类别参数表的数据  	
  declare @_zqzb char(1), /* 证券组别 */
  @_zqmc char(8), /* 证券名称 */
  @_zqlb char(1),/* 证券类别 */
  @_zjhzbz tinyint ,   /* 资金T加0回转标志 */
  @_gphzbz tinyint ,   /* 股票T加0回转标志 */
  @_jydw int,	    	/*交易单位*/	
  @_zqmz int,             /* 证券面值 */
  @_zjdjfs tinyint ,       /*资金冻结方式 */
  @_gpdjfs tinyint ,       /* 股票冻结方式*/
  @_hbzjjdfx tinyint , /* 回报资金解冻方向*/
  @_hbgpjdfx tinyint  /* 回报股票解冻方向*/
  -- 声明资金和证券的实际买卖方向 1 买 2 卖 0 不处理
  declare @zqmmfx tinyint,@zjmmfx tinyint
  select @cllr=0
  -- 声明资金证券变化量
  declare @zjdjjs money, /* 资金冻结减少*/
 	@zjjdzj  money, /* 资金解冻增加 */ 
        @zqdjjs  int, /* 证券冻结减少*/
        @zqjdzj  int  /* 证券解冻增加*/
	
  -- 声明费用数据
  declare @fy1 money,/* 到目前为止的普通费用 */ @fy2 money /* 本次特殊费用 */ ,
	@qsfy money,@sxf money
  -- 声明其他变量
  declare @ywh int,  /* 业务号 */	
	@hbdm	char(1), /* 货币代码 */
	@today  int,
	@now	int,
	@khlb   char(1), /* 客户类别 */
	@glzkhh int,
	@clbz   smallint /* 处理标志 */
  select @clbz=0	
  -- 0 对输入参数的基本验证
  -- a) 验证成交日期与系统日期
  exec com_getrqsj null,@today output,@now output
  if convert(int,@icjrq)<>@today
  begin	
	select 'N','成交日期与系统日期不一致'
	return
  end 
  -- b)检查回报是否已处理(在成交明细中),使用市场、申报代码（股东代码）、合同号、成交编号、买卖方向匹配
  if exists(select 1 from ztjyk..khsscjmx (nolock) 
	where scdm=@iscdm and sbdm=@igddm and hth=@ihth and cjbh=@icjbh and bs=@ibs) 
  begin
 	select 'N','已经处理过'
 	return
  end 	
  
  -- 1 获得证券类别参数
  -- a) 在证券代码表中获取证券类别
  select @_zqlb=null
  select @_zqlb=zqlb,@_zqzb=zqzb,@_zqmc=zqmc 
  from ztjyk..zqdm (nolock)
  where zqdm=@izqdm and scdm=@iscdm
  
  if @_zqlb is null 
  begin
	select @clbz=-1
    	select 'N','找不到证券'
    	goto insertDetailOnly
  end 
 
  -- b) 获得证券类别参数
  select  @_zjhzbz = zjhzbz,@_gphzbz = gphzbz,  @_jydw =jydw, @_zqmz =zqmz,          
  	@_zjdjfs = zjdjfs, @_gpdjfs = gpdjfs, @_hbzjjdfx =hbzjjdfx,@_hbgpjdfx=hbgpjdfx
  from ztjyk..zqlbcs (nolock)
  where zqlb=@_zqlb and scdm=@iscdm

  -- c) 检查不处理的类别,由以后的版本处理
  if @_zqlb in ('3' /* 国债购回 */ )  or @_zqlb is null
  begin
	select @clbz=-2
    	select 'X','不处理'
    	goto insertDetailOnly
  end
  -- d) 获得货币代码	
  select @hbdm=null
  select @hbdm=hbdm
  from ztjyk..sccycs (nolock)
  where scdm=@iscdm
  if @hbdm is null
  begin
	select @clbz=-3
	select 'N','货币代码错'
    	goto insertDetailOnly	
  end	
  --e) 根据证券类别参数确定资金和证券的实际买卖方向
  -- 资金
  if @_hbzjjdfx=0 --回报方向相同
    select @zjmmfx=@ibs
  else if @_hbzjjdfx=1 --回报方向相反
    select @zjmmfx=3-@ibs
  else if @_hbzjjdfx=2 --全冻结
    select @zjmmfx=1
  else if @_hbzjjdfx=3 --全解冻
    select @zjmmfx=2	
  else if @_hbzjjdfx=4 --不处理
    select @zjmmfx=0	
  else 
  begin
	select @clbz=-14
    	select 'N','系统参数错误'
    	goto insertDetailOnly
  end
  -- 证券
  if @_hbgpjdfx=0 --回报方向相同
    select @zqmmfx=@ibs
  else if @_hbgpjdfx=1 --回报方向相反
    select @zqmmfx=3-@ibs
  else if @_hbgpjdfx=2 --全冻结
    select @zqmmfx=1
  else if @_hbgpjdfx=3 --全解冻
    select @zqmmfx=2	
  else if @_hbgpjdfx=4 --不处理
    select @zqmmfx=0
  else 
  begin
	select @clbz=-14
    	select 'N','系统参数错误'
    	goto insertDetailOnly
  end
  -- 2 在委托回报库中对委托回报配对
 -- a)获得来自委托回报库的数据,并初始化委托回报库的新数据	
  select @_wtxh=null	
  -- 使用市场和申报代码（股东代码）匹配
  select @_wtxh = wtxh,@_scdm  = scdm,@_sbry  = sbry,@_sbsj  = sbsj,@_sbxh  = sbxh,
  	@_cjsl  = cjsl,@_zhsl  = zhsl,@_cjjg  = cjjg,@_cjje  = cjje,@_yxrq  = yxrq,
  	@_xwdm  = xwdm,	@_rq = rq,@_wtzt  = wtzt,@_err   = err,	@_cjsj  = cjsj,
  	@_wtsl  = wtsl,	@_cjbs  = cjbs,	@_fy1   = fy1, 	@_fy2   = fy2, 	@_khh   = khh,
  	@_sbdm  = sbdm,	@_gddm  = gddm,	@_zqdm  = zqdm,	@_mmlb  = mmlb,	@_wtjg  = wtjg,
  	@_djje  = djje
  from ztjyk..wthbk
  where sbxh=@ihth and scdm=@iscdm
  
  select @new_cjsl =@_cjsl, @new_cjjg =@_cjjg,@new_cjje =@_cjje,@new_cdcgsj =@_cdcgsj,
  	@new_wtzt =@_wtzt,@new_err =@_err,@new_cjsj =@_cjsj,@new_wtsl =@_wtsl,
  	@new_cjbs =@_cjbs, @new_fy1 =@_fy1, @new_fy2 =@_fy2
  -- b)如果合同号不匹配
  if (@_wtxh is null) 
  begin
	select @clbz=-4,@_gddm=@igddm
    	select 'N','合同号不匹配'
    	goto insertDetailOnly 
  end	
  -- c)如果合同号匹配,开始校验数据
  --获得客户类别和主账号	
  select @khlb=null
  select @khlb=khlb,@glzkhh=glzkhh from ztjyk..khzl where khh=@_khh
  if (@khlb is null)
  begin
	select @clbz=-5
    	select 'N','客户不存在'
	goto insertDetailOnly	
  end
  if (@_sbdm<>@igddm)
  begin
	select @clbz=-6
    	select 'N','股东代码不匹配'
    	goto insertDetailOnly
  end 
  if (@_zqdm<>@izqdm)
  begin
	select @clbz=-7
	select 'N','证券代码不匹配'
    	goto insertDetailOnly
  end 
  /************* 处理: 指定撤消、指定交易 *************/
  if (@zjmmfx=0 and @zqmmfx=0)  --回报资金解冻方向和回报证券解冻方向都是不处理
  begin
	select @zjdjjs=0.00,@zjjdzj=0.00,@zqdjjs=0,@zqjdzj=0
	select @clbz=5,@new_wtzt=7 /* 成交 */
	goto StartProcess
  end	
  /********************************/
  --继续校验数据
  if  (@_mmlb not in ('1','2') /* 买卖类别不是买入.卖出*/)
  begin
	select @clbz=-8
	select @cllr=3  -- 其他
	goto speicalTreat
  end	
  if  (@_mmlb<>@ibs)
  begin
	select @clbz=-9
	select 'N','买卖方向不匹配' 
	goto insertDetailOnly
  end
  if (@icjsl>0) and (@icjjg>0) 
  begin
	select @cllr=1  -- 成交
	-- @_mmlb or @zjmmfx?
	if (@_mmlb=1 and @icjjg>@_wtjg) or (@_mmlb=2 and @icjjg<@_wtjg)
  	begin
		select @clbz=-10
 		select 'N','价格超出委托范围'
   		goto insertDetailOnly 
  	end
  end  
  else if (@icjsl<0) and (@icjjg=0) 
  begin
	select @cllr=2  -- 撤单
  end  
  else 
  begin 
	select @clbz=-11
	select @cllr=4  -- 错误
	select 'N','成交价格和数量为负'
	goto insertDetailOnly 
  end
  if @cllr=1
  begin
    if (@icjsl+@_cjsl>@_wtsl)
    begin
	select @clbz=-12
	select 'N','成交数量超过委托数量'
	goto insertDetailOnly
    end	
  end 
  else if @cllr=2
  begin
    if (@_wtsl<-@icjsl)
    begin
	select @clbz=-13
	select 'N','撤单数量超过委托数量'
	goto insertDetailOnly
    end
  end

  
  /********** 3 开始计算资金证券变化量 ************/
  select @zjdjjs=0.00,@zjjdzj=0.00,@zqdjjs=0,@zqjdzj=0
  if @cllr=1
  begin
    /*************  a)处理成交数据 ************/
    -- i)计算累计成交金额,成交数量,成交价格,成交笔数
    select @new_cjje=@_cjje+@icjje,@new_cjsl=@_cjsl+@icjsl,@new_cjbs=@_cjbs+1,@new_cjsj=@icjsj
    if @new_cjsl>0 select @new_cjjg=@new_cjje/@new_cjsl
    -- ii)计算费用
    select @fy1=0,@fy2=0
    -- 计算普通费用,使用累加后的成交数量和成交金额(调用存储过程的价格=0,因为指定了成交金额)
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,0 /*佣金 */,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,2 /*过户费 */,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,3 /*清算费用*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,4 /*其他费用1*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    -- 计算本次特殊费用,使用本次成交数量和成交金额
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,4 /*印花税*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@icjsl,1,0,@icjje,@fy2 output,@sxf output
    -- 设定@new_fy1,new_fy2
    select @new_fy1=@fy1,@new_fy2=@fy2+@_fy2         			
    if @zjmmfx=1 
    begin
	-- iii)处理资金买
	if @new_cjsl=@_wtsl
	begin
	-- 全部成交,
	--冻结金额的减少值 =（该笔委托的初始）冻结金额 - （累计）成交金额 - 普通费用 -（累计）特殊费用。
	      select @zjdjjs=@_djje-@new_cjje-@new_fy1-@new_fy2
	end 
	/*	else
	begin
	  -- 部分成交,不解冻资金 
	end */
    end 
    else if @zjmmfx=2 
    begin
	-- iv)处理资金卖
	if @_zjhzbz=1 
	begin
	  -- 如果资金T+0回转,全部成交与部分成交的计算相同
	  -- 解冻金额增加 = 本次成交金额 - （到本次）普通费用（的增加值）- （本次）特殊费用	
          	select @zjjdzj=@icjje - (@new_fy1-@_fy1) - @fy2
	end
    end
    if @zqmmfx=1
    begin
	-- v)处理证券买
	if @_gphzbz=1
	begin
	--如果证券T+0回转
		select @zqjdzj=@icjsl
	end 
    end	
    /*  else if @zqmmfx=2
    begin
	-- vi)处理证券卖:无证券冻结/解冻处理
    end  */
    if @_wtzt not in ('a' /*部撤单 */ ,'b' /* 已撤单*/)	
	if @new_cjsl=@_wtsl
		select @new_wtzt='7' else --已成交  
		select @new_wtzt='6' --部成交
  end 
  else if @cllr=2
  begin
    /*************  b)处理撤单数据 ************/
    select @new_cdcgsj=@icjsj	
    select @new_wtsl=@_wtsl+@icjsl -- @icjsl<0 !	
    if @zjmmfx=1 
    begin
	-- i)撤销资金买
	if @new_wtsl=0 
	--如果撤单以后无未成交数量,才解冻金额
	--冻结金额的减少值 =（该笔委托的初始）冻结金额 - （累计）成交金额 - 普通费用 -（累计）特殊费用。
		--等价与 select @djjejs = @_djje - @_cjje - @_fy1 - @_fy2
		select @zjdjjs=@_djje-@new_cjje-@new_fy1-@new_fy2
    end 
    /* else if @zjmmfx=2 
    begin
	-- ii)撤销资金卖,无资金冻结/解冻处理 
    end */
    if @zqmmfx=2
    begin
	-- iii)撤销证券卖,证券冻结数减少 = 撤单数量
	select @zqdjjs=-@icjsl -- @icjsl<0
    end
    /* else
    begin
	-- iv)撤销证券买	,无证券冻结/解冻处理
    end	*/		
    if 	@new_wtsl=0
	select @new_wtzt='b' else	--已撤单
	select @new_wtzt='a' 		--部撤单
  end
  /*********** 4 开始修改数据库 ****************/
  StartProcess:
  begin transaction cjhb
	declare @Msg char(50)
	select @Msg="实时成交转换成功"
        -- a) 修改委托回报库
 	update ztjyk..wthbk
	set   	cjsl=@new_cjsl ,cjjg=@new_cjjg,	cjje=@new_cjje,	cdcgsj=@new_cdcgsj,
  	 	wtzt=@new_wtzt,	err=@new_err, 	cjsj=@new_cjsj, wtsl=@new_wtsl,
  	 	cjbs=@new_cjbs, fy1=@new_fy1, 	fy2=@new_fy2    
  	where wtxh=@_wtxh
	if @@error<>0 goto PROCESS_ERROR
        -- b) 插入资金证券临时冻结解冻表
	if  (@zqdjjs<>0 or @zqjdzj<>0 or abs(@zjdjjs)>0.00001 or abs(@zjjdzj)>0.00001)
 	begin
          if @zjmmfx=1 or @zqmmfx=1
		select @ywh=803 else
		select @ywh=804
	  -- 冻结 :- ,解冻: +
	  declare @lsh numeric
          exec com_lsh 0,3,@lsh output				
	  insert into ztjyk..zjzqlsdjjd(lsh,ywh,khh,hbdm,scdm,wtxh,wthth,je,zqdm,fssl)
	  values(@lsh,@ywh,@_khh,@hbdm,@iscdm,@_wtxh,@ihth,@zjjdzj-@zjdjjs,@izqdm,@zqjdzj-@zqdjjs)
	end
	if @@error<>0 goto PROCESS_ERROR
	-- c) 修改客户资金表 :资金冻结减少,	资金解冻增加
        if (abs(@zjdjjs)>0.00001 or abs(@zjjdzj)>0.00001)
	begin
		update  ztjyk..khzj
		set djje=djje-@zjdjjs,jdje=jdje+@zjjdzj
		where 	khh=@_khh and hbdm=@hbdm
	end
	if @@error<>0 goto PROCESS_ERROR
	-- d) 修改客户证券 :证券冻结减少,证券解冻增加
	if @zqdjjs<>0 or @zqjdzj<>0
	begin
		if @_gpdjfs=0 
		begin
		  -- 按股票
		  declare @mrzj int/* 当日买入数增加 */,@mczj int /*当日卖出数增加 */,
			@mrjezj money /*当日买入金额增加 */ ,@mcjezj money /* 当日卖出金额增加*/ 
		  if @zqmmfx=1
		  	select @mrzj=@icjsl,@mczj=0,@mrjezj=@icjje,@mcjezj=0 else
			select @mrzj=0,@mczj=@icjsl,@mrjezj=0,@mcjezj=@icjje
		  update ztjyk..tgk
		  set	djs=djs-@zqdjjs,jds=jds+@zqjdzj,
			drmrs=drmrs+@mrzj,drmcs=drmcs+@mczj,
			drmrje=drmrje+@mrjezj,drmcje=drmcje+@mcjezj
		  where gddm=@_gddm /* @_gddm来自回报库 */ and scdm=@iscdm and zqdm=@izqdm
		  if @@error<>0 goto PROCESS_ERROR	
		  if @@rowcount=0
		  begin
			-- 无该种证券
			declare @_gdxm char(10),@_jjrh smallint
			select @clbz=2
			select @_gdxm=xm
			from ztjyk..gddmb
			where	gddm=@_gddm and scdm=@iscdm
			if @@error<>0 goto PROCESS_ERROR	

			select @_jjrh=jjrh
			from	ztjyk..jjrglkh
			where  khh=@_khh
			if @@error<>0 goto PROCESS_ERROR

			insert into ztjyk..tgk(
				gddm, zqdm, scdm, gdxm, khh, glzkhh, sbdm, zqlb, zqzb, kcs, djs, jds, 
				qsdjs,qsjds, cqdjs, bdrq, cccb, drmrs, drmcs, drmrje, drmcje, psrgsl, 
				sz, jjrh,mrwjssl, mcwjssl, dysl, khlb, zqmc)
			values(@_gddm,@izqdm,@iscdm,@_gdxm,@_khh,@glzkhh,@igddm,@_zqlb,@_zqzb,0,-@zqdjjs,@zqjdzj,
				0,0,0,null,null,@mrzj,@mczj,@mrjezj,@mcjezj,0,
				null,@_jjrh,0,0,0,@khlb,@_zqmc)
			if @@error<>0 goto PROCESS_ERROR
			select @msg="成功插入"
		  end	else		
			select @clbz=1
 		end else 
		begin
		  -- 按标准券
		  select @clbz=3			
		  update ztjyk..hgkhdyq
		  set djs=djs-@zqdjjs
		  where khh=@_khh and scdm=@iscdm
		  if @@error<>0 goto PROCESS_ERROR
		end
	end else
	  if @clbz=0 select @clbz=4
	-- e) 如果是指定交易,修改股东账号表
	if @_zqlb in ('b','c')  
	begin
		declare	@zdbz tinyint
		if @_zqlb='b' --指定交易	
			select @zdbz=1 else 
			select @zdbz=0
		update  ztjyk..gddmb
		set zdbz=@zdbz
		where	gddm=@_gddm and scdm=@iscdm
		if @@error<>0 goto PROCESS_ERROR
		if @@rowcount=0 select @clbz=6
	end
  	-- f) 向客户实时成交明细表插入记录
  	insert into ztjyk..khsscjmx(khh,khlb,scdm,gddm,bs,zqdm,zqlb,sbdm,cjrq,cjbh,xwdm,scye,cjsl,sbsj,cjsj,cjjg,cjje,hth,bz,clbz)
  	values(@_khh,@khlb,@iscdm,@_gddm,@ibs,@izqdm,@_zqlb,@igddm,@icjrq,@icjbh,@ixwdm,@iscye,@icjsl,@isbsj,@icjsj,@icjjg,@icjje,@ihth,@ibz,@clbz)
  PROCESS_OVER: 
  if @@error=0           /*sql 成功*/
  begin
	commit transaction cjhb
	select "Y",@Msg
  end
  else	                 /*sql 失败*/
  begin
  PROCESS_ERROR:
	rollback transaction cjhb
	select "N","实时成交转换失败"
  end    
  return
  /*******************   结束正常处理    *******************/
speicalTreat:  -- 特殊处理:买卖类别不是买入/卖出 转托管,配股,转股,回售
  select   "X","暂时不处理" -- 暂时不处理	
  goto insertDetailOnly
  --return
  /*******************  处理数据验证错误 ************************/
insertDetailOnly:  --只向客户实时成交明细表插入记录,不修改其他表
  /* 注意: 申报代码=输入参数的股东代码(一级),股东代码=回报库的股东代码(一级或者二级)*/
  insert into ztjyk..khsscjmx(khh,khlb,scdm,gddm,bs,zqdm,zqlb,sbdm,cjrq,cjbh,xwdm,scye,cjsl,sbsj,cjsj,cjjg,cjje,hth,bz,clbz)
  values(@_khh,@khlb,@iscdm,@_gddm,@ibs,@izqdm,@_zqlb,@igddm,@icjrq,@icjbh,@ixwdm,@iscye,@icjsl,@isbsj,@icjsj,@icjjg,@icjje,@ihth,@ibz,@clbz)
  return   
end
GO

/*
*************   test
select * from ztjyk..khll
declare @zll money
select @zll=null
select @zll=zll from ztjyk..khll where khh=1
select @zll

use ztjyk
sp_help wthbk
*/

--select * from ztjyk..wthbk
--select wtzt,zqdm from ztjyk..wthbk
--select * from ztjyk..tgk
--select * from ztjyk..khsscjmx
--select * from ztjyk..wtk


/*
select * from ztjyk..zqlbcs
where zqlb in ('b','c')

update ztjyk..zqlbcs
set hbzjjdfx=4,hbgpjdfx=4
where zqlb in ('b','c')

select khh,gddm,zdbz from  ztjyk..gddmb
where khh=1010000018
*/