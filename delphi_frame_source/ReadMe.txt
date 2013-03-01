黄燕来共享代码库的目录结构
  MyLib\          共享代码库的主要代码
  TestMyLib\      共享代码库的测试(也用于示例)
  Example\        共享代码库的示例
  activeX\        导入的ActiveX控件和TypeLib，以及相应的例子
    \ActiveMovie  ActiveMovie的使用例以及类包装
    \BookViewer   可以看微星图书(*.001,*.002)的程序
  import\         导入的第三方代码库，以及我的修改或者对象包装
    \ImageLib     显示/保存图像文件的库(支持BMP,GIF,JPEG,TIFF,PCX,PNG)
    \PosControl2  Pos的控件(需要RXLib以及Delphi3.0)
    \dblib        使用dblib访问sqlserver的dblib函数声明以及类包装
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Packages:
  User.dpk        包含基本的控件以及实用类和函数(Run-Time Only，User.BPL必须位于Path)
  dUser.dpk       注册User.dpk到Delphi IDE,包括设计时Wizard(Design-Time)
  CoolPkg.dpk        包含一些特殊外观的控件(Run-Time Only，User.BPL必须位于Path)
  dCoolPkg.dpk       注册Cool.dpk到Delphi IDE,包括设计时Wizard(Design-Time)
  ImageLib.dpk    显示/保存图像文件的控件(Run Time&Design Time)

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
安装方式
  1. 安装了Delphi4和Update Pack 3,或者delphi5
  2. 复制以上所有目录到本机
  3. 在Delphi中打开MyLib\user.dpk, Compile (编译产生的user.bpl自动放置于delphi\bin)
  4. 在Delphi中打开MyLib\duser.dpk, Compile,Install
  5. 在Delphi中打开MyLib\CoolPkg.dpk,Compile (编译产生的Coolpkg.bpl自动放置于delphi\bin)
  6. 在Delphi中打开MyLib\dCoolPkg.dpk,Compile,Install
  7. 在Delphi中打开import\ImageLib\ImageLib.dpk,Compile,Install

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

特别推荐:
    DebugMemory,LogFile,Safecode : 编写正确delphi程序的工具


说明：

附：标记方式：  (Unit),[Component]

User.dpk
(Ability Managers) : 包含控件的Enable/Disable属性的管理，适用于权限管理。
    1. Ability Manager(能力管理者) :     管理控件的Enable/Disable
    公共属性：Enable,Visible,VisibleOnEnabled,OnEnableChanged,OnVisibleChanged,AbilityProvider
    公共方法: CheckEnabled,CheckVisible
    [TAbilityManager]
    [TSimpleAbilityManager] 属性:MenuItem,Control
    [TGroupAbilityManager]  属性:MenuItems,Controls

    2.Authority Provider(权限提供者) :  提供权限标志
    公共属性：OnAuthorityChanged; 公共方法: GetAuthorityAsInteger,GetAuthorityAsString
    [TSimpleAuthorityProvider] 属性：AuthorityAsInteger,AuthorityAsString
    [TDBAuthorityProvider]     属性：autoActive,Active,AuthorityQuery,UserID,DefaultAuthorityInteger,DefaultAuthorityString,SeperateChar

    3.Ability   Provider(能力提供者) :  连接能力管理者和权限提供者。
    根据权限提供者提供的权限标志，进行运算，决定能力管理者的Enable/Disable，然后能力管理者影响控件。
    公共属性：AbilityManager,AuthorityProvider,OnAbilityChanged,DefaultEnabled

    [TAbilityProvider]  属性:ProviderType,AsInteger,AsString,OnCustomCalc

(AMovieUtils): 包装ActiveMovie接口
    [TMovieWnd] 显示Movie的窗口
        属性：AutoRewind:自动回绕; Opened: 打开/关闭Movie; FileName;Interval;EnableTimer
        事件：OnStateChanged;OnTimer;AfterOpen;OnPlayComplete;

(BkGround) : 包含背景控件，使得其上的控件透明
    [TBackGround]:  Tiled,Picture,Transparent,OnFilterControl

(ClipbrdMon) : 监视剪切板变化的组件 

(ComboLists) : 包含几个下拉框
    [TCustomCodeValues] : 包含一系列的Code-Value组(代码表)
    [TCustomComboList] : 下拉框显示TCustomCodeValues的Value值，返回实际Code
                  功能：直接输入代码；输入Value在下拉框中定位；过滤
    [TDBCodeValues] : 通过Query从数据库获得Code-Value组
    [TComboList]
    [TDBComboBoxList] 数据敏感的TComboList，数据库保存Code,控件中显示/选择Value

(CompGroup) : 包含各种“组件集合”
    [TComponentGroup] 组件集合 属性：Components
    [TAppearanceGroup] 具有一致外观(字体，颜色)的组件集合，属性：Components,Color,Font
    [TAppearanceProxy] 外观代理，和FontDialog,ColorDialog,ProxyComponent关联。
        用户鼠标点击以后，出现FontDialog/ColorDialog,修改外观代理的Font/Color，然后通过外观代理修改ProxyComponent的Font/Color
        属性：OnColorChanged,OnFontChanged,ProxyComponent,ColorDialog,FontDialog,ConfigColorOn,ConfigFontOn

(CompUtils) : 扩充标准组件的使用方法的工具

(ComWriUtils) : Components writers' utilities

(Container)
    [TContainerProxy] 在设计时代表TContainer的位置大小，属性：ContainerClassName

(DBListOne) : 包含数据来自Dataset的List,ComboBox
    [TDBListOne] 数据来自Dataset的Listbox,属性：SelectText，DataField,DataSource
    [TDBComboList] 数据来自Dataset的ComboBox,属性：DataField,DataSource,DropDownCount,DropDownWidth

(DebugMemory) : 调试内存泄漏

(Design) : 包含设计控件
    [TDesigner] : 设计控件，放置在它上面的控件可以使用鼠标改变大小和位置
        属性:Designed;PlaceCtrlCursor;NotDesignNewCtrl;FocusOnNewCtrl;
        运行属性:DesignCtrl;PlaceNewCtrl
        事件:OnPlaceNewCtrl;OnDesignCtrlChanged;OnDelete;OnCtrlSizeMove

(DragMoveUtils) 包含鼠标拖动改变控件大小/位置的工具

(DrawUtils) 画图工具

(ExtDialogs) 包含扩充的对话框
    [TPenDialog]  设置Pen属性的对话框
        属性：Title,Pen
    [TOpenDialogEx] 扩充OpenDialog,具有收藏夹功能
        属性: StartInFavorites;NewStyle;IsSaveDialog;TextCtrl;
    [TFolderDialog] 选择目录的对话框
        属性: Folder;TextCtrl;

(extutils) 包含常用函数(文件处理，字符串处理等等)

(FontStyles) : 字体风格的展示
    [TFontStyles] 包含多种字体，可以在PopupMenu,MenuItem,ListBox中显示这些字体
        属性: Styles;PopupMenu;MenuItem;ListBox

(GridEx) : 包含对StringGrid的扩展
    [TStringGridEx] : 对StringGrid的扩展。功能：可以指定固定行列的字体；文字折行；保存到文件
        属性: FixColFont,FixFont,TopLeftFont,WordWrap

(HotKeyMons) : 包含系统热键组件
    [THotKeyMonitor] : 可以定义一个系统热键，当用户按下热键以后，触发事件
        属性: Active;ShortCut;Modifiers;OnHotKey

(IntfUtils) : 实现接口的基础类

(IPCUtils) : 包含进程间通信的工具类

(LibMessages) : 包含MyLib用到的自定义Windows消息代码

(LogFile) : 写Log文件的工具

(MenuUtils) : 菜单工具

(MovieViewer):播放Movie
    [TMovieView] : 播放Movie的控件
        属性：Active;CtrlVisible;AutoRewind;FileName;StateChanged;AfterOpen;OnPlayComplete

(PenCfgDlg) : 包含设置Pen属性的界面
    [TdlgPenCfg] : 包含设置Pen属性的界面

(RTFUtils) : RichEdit扩充
    [TRichView] : 支持文本中的热点
    [THyperTextView]: 将热点信息保存在附属文件中
    [THyperTextViewEx] : 通过增加空行的方式设定行间距

(Safecode) : 编写可靠代码的类似断言的判断

(ShellUtils) : 包装Win32的Shell接口
    [TTrayNotify] : 任务栏图标
        属性：Tip;ShowButton;Active;Icon;LeftPopup;RightPopup;OnLeftClick;OnRightClick;OnDblClick;OnMouseEvent
    [TMultiIcon]  : 任务栏动画图标
        属性：ImageList,CurIndex,Animate,StartIndex,EndIndex,Interval
    [TShellFolder] : 包装IShellFolder接口，可以在ListView中显示包含的文件
        属性：Path,ListView,OnPathChanged,Sorted,Options,OnItemsChanged,
              Filtered,OnFilter,Mask,CanEnterSub
    [TFileOperation] : 包装SHFileOperation，完成文件操作
        属性：Sources,Dests,Operation,Options,Title,Simple,Source,Dest

(SimpBmp) : 包装Windows的Bitmap,功能比TBitmap简单，速度快

(SimpCtrls) : 继承TLable,TSpeedButton，在Caption中增加'\n'表示换行
    [TLabelX]: 继承TLable在Caption中增加'\n'表示换行
    [TSpeedButtonX]: 继承TSpeedButton在Caption中增加'\n'表示换行

(StorageUtils) : 使用IniFile的工具

(TypUtils) : RunTime-Type-Information 工具

*********************************************************

CoolPkg.dpk
(BtnLookCfgDLG) : 设置按键的外观的界面

(CoolCtrls) : 具有特殊外观的Label,Button
    [TCoolLabel] : 对Lable扩充，具有位图
    [TLabelOutlook]: 决定TCoolLabelX的外观
    [TCoolLabelX]: 对Lable扩充，外观由TLabelOutlook决定
    [TButtonOutlook] : 决定TCoolButton的外观
    [TPenExample] : 显示Pen的效果的控件
    [TAniButtonOutlook] : 设定TAniCoolButton的外观
    [TAniCoolButton] : 动画按键。外观由TAniButtonOutlook决定

(ImageFXs) : 特殊效果图像
    [TImageFX] : 特殊效果图像，特殊效果来自TCustomFXPainter
    [TFXScalePainter] : 放缩的特殊效果
    [TFXStripPainter] : 条带的特殊效果
    [TFXDualPainter]  : 双边的特殊效果

(LabelLookCfgDLG) : 设置Label的外观的界面

*********************************************************

ImageLib.dpk

(ImageLibX) :ImageLib的函数声明

(ImgLibObjs) : 包装ImageLib
    [TILImage] : 显示图像的控件。(使用TBitmap保存HBitmap)
    [TILImageView] : 显示图像的控件。(使用TSimpleBitmap保存HBitmap)
