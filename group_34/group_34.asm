        .386
        .model  flat,stdcall
        option  casemap:none

IDM_EXIT        equ     4000

include         windows.inc
include         user32.inc
include         gdi32.inc
include         kernel32.inc
includelib      user32.lib
includelib      gdi32.lib
includelib      kernel32.lib


WndProc         proto   :HWND,:UINT,:WPARAM,:LPARAM
DrawStr         proto   :DWORD,:DWORD           ;12 宣告 DrawStr 函式原型
DrawStr1        proto   :DWORD,:DWORD
MAX_Read        equ     16384
fieldbkcolor    equ     0h
;***********************************************************
        .DATA
hMenu           HMENU       ?
hInstance       HINSTANCE   ?
hwnd            HWND        ?
hBitmap         dd          ?   ;022 位元圖物件代碼
bBitmap         dd          ?
nBitmap         dd          ?
nxClient        dd          ?   ;023 工作區寬度
nyClient        dd          ?   ;024 工作區高度
ncx             dd          ?   ;025 BMP 圖檔的寬度
ncy             dd          ?   ;026 BMP 圖檔的高度
bcx             dd          ?
bcy             dd          ?
ClassName       db          'ViewBMPWinClass',0
AppName         db          '燈燈燈冷',0
MenuName        db          'VBMPMenu',0
IconName        db          'BMPIcon',0
BMPName         db          'VBMP',0
BBMPName        db          'BBMP',0
bBMPName        db          'TALKBLOCK',0
nBMPName        db          'NAMEBLOCK',0
wc              WNDCLASSEX  <?>
msg             MSG         <?>
wordspace       RECT        <70,568,800,640>
namespace       RECT        <45,500,130,530>
picturespace    RECT        <0,0,872,567>
wordd           db          '燈燈燈冷',0
filename        db          'story\demoline0.txt',0
filehandle      HFILE       ?
buffer          db          MAX_Read dup(0),0
nReadBytes      dd          0
magicfont       HFONT       ?
count           dd          0
wordnumber      dd          0
wordout         dd          ?
character0       db          '我',0
character1       db          '小龍',0
character2       db          '阿驢',0
character3       db          '小馬',0
character4       db          '小尻',0
character10      db          '    ',0
peoplenow        db          0
musictest       db          'music\braveshine.wav',0
switchh         db          0
beenwritten     dd          1
keyin           db          0
D11             db          'D1_1',0
D12             db          'D1_2',0
D13             db          'D1_3',0
D14             db          'D1_4',0
D15             db          'D1_5',0
D16             db          'D1_6',0
D17             db          'D1_7',0
D18             db          'D1_8',0
D19             db          'D1_9',0
D110             db          'D1_10',0
D111             db          'D1_11',0
D112             db          'D1_12',0
D113             db          'D1_13',0
D114             db          'D1_14',0
D115             db          'D1_15',0
D116             db          'D1_16',0
D117             db          'D1_17',0
D118             db          'D1_18',0
D122             db          'D1_22',0
D21             db          'D2_1',0
D22             db          'D2_2',0
D23             db          'D2_3',0
D24             db          'D2_4',0
D25             db          'D2_5',0
D26             db          'D2_6',0
D27             db          'D2_7',0
D28             db          'D2_8',0
D29             db          'D2_9',0
D210             db          'D2_10',0
D211             db          'D2_11',0
D212             db          'D2_12',0
D213             db          'D2_13',0
D214             db          'D2_14',0
D215             db          'D2_15',0
D30             db          'D3_0',0
D31             db          'D3_1',0
D32             db          'D3_2',0
D33             db          'D3_3',0
D34             db          'D3_4',0
D35             db          'D3_5',0
D36             db          'D3_6',0
D37             db          'D3_7',0
D335             db          'D3_35',0
D345             db          'D3_45',0
D40             db          'D4_0',0
D41             db          'D4_1',0
D42             db          'D4_2',0
D43             db          'D4_3',0
D44             db          'D4_4',0
D45             db          'D4_5',0
D46             db          'D4_6',0
D47             db          'D4_7',0
D48             db          'D4_8',0
D49             db          'D4_9',0
D410             db          'D4_10',0
D411             db          'D4_11',0
D471             db          'D4_71',0
D472             db          'D4_72',0
D475             db          'D4_75',0
D476             db          'D4_76',0
D51             db          'D5_1',0
D52             db          'D5_2',0
D53             db          'D5_3',0
D54             db          'D5_4',0
D60             db          'D6_0',0
D61             db          'D6_1',0
D62             db          'D6_2',0
D63             db          'D6_3',0
D64             db          'D6_4',0
D65             db          'D6_5',0
D66             db          'D6_6',0
D67             db          'D6_7',0
D68             db          'D6_8',0
D69             db          'D6_9',0
D610             db          'D6_10',0
D611             db          'D6_11',0
D633             db          'D6_33',0
d8             db          'D8',0
D81             db          'D8_1',0
D82             db          'D8_2',0
D83             db          'D8_3',0
D84             db          'D8_4',0
d888             db          'D888',0
;***********************************************************
        .CODE

start:
        ;invoke  PlaySound,offset musictest,NULL,SND_ASYNC or SND_LOOP
        invoke  CreateFile,offset filename,GENERIC_READ, \
                FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, \
                NULL
.if eax!=INVALID_HANDLE_VALUE
    mov     filehandle,eax
    invoke  ReadFile,filehandle,offset buffer,MAX_Read, \
            addr nReadBytes,NULL
    mov     edx,nReadBytes
    mov     buffer[edx],0
    invoke      CloseHandle,filehandle
.else
    invoke  DestroyWindow,hwnd
.endif
        invoke  CreateFont,25,12,0,0,FW_SEMIBOLD,FALSE,FALSE,FALSE, \
                CHINESEBIG5_CHARSET,OUT_STRING_PRECIS,CLIP_EMBEDDED, \
                DEFAULT_QUALITY,FF_MODERN,NULL
        mov     magicfont,eax

        invoke  GetModuleHandle,NULL
        mov     hInstance,eax
        mov     wc.cbSize,sizeof WNDCLASSEX
        mov     wc.style,CS_HREDRAW or CS_VREDRAW
        mov     wc.lpfnWndProc,offset WndProc
        mov     eax,hInstance
        mov     wc.hInstance,eax
        invoke  LoadIcon,hInstance,offset IconName
        mov     wc.hIcon,eax
        mov     wc.hIconSm,eax
        invoke  LoadCursor,NULL,IDC_ARROW
        mov     wc.hCursor,eax
        mov     wc.hbrBackground,COLOR_WINDOWTEXT+1
        invoke  LoadMenu,hInstance,offset MenuName
        mov     hMenu,eax
        mov     wc.lpszClassName,offset ClassName
        invoke  RegisterClassEx,offset wc
        invoke  CreateWindowEx,NULL,offset ClassName,offset \
                AppName,WS_CAPTION or WS_SYSMENU \           ;058 風格
                ,300,50,877,709,0,hMenu,hInstance,NULL
        mov     hwnd,eax
        invoke  ShowWindow,hwnd,SW_SHOWDEFAULT                     ;061 最大化
        invoke  UpdateWindow,hwnd
        invoke  InvalidateRect,hwnd,ADDR namespace,1
        invoke  DrawStr1,offset character10,hwnd
        invoke  SetTimer,hwnd,5,10,NULL



.while  TRUE
        invoke  GetMessage,offset msg,NULL,0,0
.break  .if     !eax
        invoke  DispatchMessage,offset msg
.endw
        mov     eax,msg.wParam
        invoke  ExitProcess,eax
;-----------------------------------------------------------
WndProc proc    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
        local   bitmap:BITMAP           ;073 存放位元圖屬性
        local   ps:PAINTSTRUCT
        local   hdc,hdcMem,bhdc,nhdc:HDC

.if uMsg==WM_CREATE
        invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
        mov     hBitmap,eax
        invoke  GetObject,hBitmap,sizeof BITMAP,addr bitmap     ;080 位元圖屬性
        mov     ecx,bitmap.bmWidth      ;081 位元圖寬度存於 ncx
        mov     ncx,ecx
        mov     ecx,bitmap.bmHeight     ;083 位元圖高度存於 ncy
        mov     ncy,ecx

        invoke  LoadBitmap,hInstance,offset bBMPName
        mov     bBitmap,eax
        invoke  GetObject,bBitmap,sizeof BITMAP,addr bitmap
        mov     ecx,bitmap.bmHeight
        mov     bcy,ecx
        mov     ecx,bitmap.bmWidth
        mov     bcx,ecx

        invoke  LoadBitmap,hInstance,offset nBMPName
        mov     nBitmap,eax
        invoke  GetObject,nBitmap,sizeof BITMAP,addr bitmap

.elseif uMsg==WM_SIZE
        mov     eax,lParam              ;087 取得工作區大小，ECX=高度，EAX=寬度
        mov     ecx,eax
        and     eax,0ffffh
        shr     ecx,16
        mov     nxClient,eax
        mov     nyClient,ecx


.elseif uMsg==WM_PAINT
        invoke  BeginPaint,hWnd,addr ps ;108 取得視窗的設備內容
        mov     hdc,eax
        invoke  CreateCompatibleDC,eax  ;110 建立相同的設備內容作為來源
        mov     hdcMem,eax
        mov     eax,hdc
        invoke  CreateCompatibleDC,eax  ;110 建立相同的設備內容作為來源
        mov     bhdc,eax
        mov     eax,hdc
        invoke  CreateCompatibleDC,eax
        mov     nhdc,eax
        invoke  SelectObject,hdcMem,hBitmap     ;112 選定來源設備內容的位元圖
        invoke  SelectObject,bhdc,bBitmap
        invoke  SelectObject,nhdc,nBitmap
        invoke  BitBlt,hdc,0,0,nxClient,nyClient,hdcMem,\
                0,0,SRCCOPY         ;118 傳送位元圖到視窗的設備內容
        invoke  BitBlt,hdc,0,525,nxClient,nyClient,bhdc,\
                0,0,SRCCOPY
        invoke  BitBlt,hdc,0,470,nxClient,nyClient,nhdc,\
                0,0,SRCCOPY
        invoke  DeleteDC,hdcMem         ;119 釋放來源設備內容
        invoke  DeleteDC,bhdc
        invoke  DeleteDC,nhdc
        invoke  EndPaint,hWnd,addr ps   ;120 釋放視窗設備內容


.elseif uMsg==WM_LBUTTONDOWN

        .if count==0
                mov peoplenow,10
                mov wordout,13
                inc count
        .elseif count==1
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D11             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,13
                mov wordout,58
                inc count
        .elseif count==2
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D12             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,71
                mov wordout,47
                inc count
        .elseif count==3
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D13             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,118
                mov wordout,109
                inc count
        .elseif count==4
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D14             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,227
                mov wordout,14
                inc count
        .elseif count==5
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D15             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,241
                mov wordout,23
                inc count
        .elseif count==6
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D16             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,264
                mov wordout,86
                inc count
        .elseif count==7
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D16             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov wordnumber,350
                mov wordout,78
                inc count
        .elseif count==8
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D17             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,428
                mov wordout,105
                inc count
        .elseif count==9
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,533
                mov wordout,10
                inc count
        .elseif count==10
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D19             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,543
                mov wordout,56
                inc count
        .elseif count==11
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D110             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,599
                mov wordout,16
                inc count
        .elseif count==12
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D111             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,615
                mov wordout,59
                inc count
        .elseif count==13
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D19             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,674
                mov wordout,79
                inc count
        .elseif count==14
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D111             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,753
                mov wordout,48
                inc count
        .elseif count==15
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D112             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,801
                mov wordout,12
                inc count
        .elseif count==16
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D113             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,813
                mov wordout,42
                inc count
        .elseif count==17
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D114             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,855
                mov wordout,116
                inc count
        .elseif count==18
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D113             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,971
                mov wordout,33
                inc count
        .elseif count==19
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D115             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,1004
                mov wordout,10
                inc count
        .elseif count==20
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1014
                mov wordout,42
                inc count
        .elseif count==21
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1056
                mov wordout,44
                inc count
        .elseif count==22
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1100
                mov wordout,51
                inc count
        .elseif count==23
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1151
                mov wordout,12
                inc count
        .elseif count==24
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1163
                mov wordout,49
                inc count
        .elseif count==25
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1212
                mov wordout,46
                inc count
        .elseif count==26
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1258
                mov wordout,55
                inc count
        .elseif count==27
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D115             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,1313
                mov wordout,13
                inc count
        .elseif count==28
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1326
                mov wordout,47
                inc count
        .elseif count==29
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1373
                mov wordout,51
                inc count
        .elseif count==30
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1424
                mov wordout,66
                inc count
        .elseif count==31
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1490
                mov wordout,47
                inc count
        .elseif count==32
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1537
                mov wordout,25
                inc count
        .elseif count==33
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1562
                mov wordout,77
                inc count
        .elseif count==34
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1639
                mov wordout,17
                inc count
        .elseif count==35
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1656
                mov wordout,3
                inc count
        .elseif count==36
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1659
                mov wordout,92
                mov keyin,1
        .elseif count==37

        .elseif count==38

        .elseif count==39
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1839
                mov wordout,38
                inc count
        .elseif count==40
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D117             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1877
                mov wordout,5
                inc count
        .elseif count==41
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,1882
                mov wordout,12
                inc count
        .elseif count==42
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D21             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,1894
                mov wordout,10
                inc count
        .elseif count==43
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D22             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,1904
                mov wordout,52
                inc count
        .elseif count==44
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D23             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,1956
                mov wordout,21
                inc count
        .elseif count==45
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D22             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,1977
                mov wordout,63
                inc count
        .elseif count==46
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D23             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2040
                mov wordout,14
                inc count
        .elseif count==47
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D24             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2054
                mov wordout,40
                inc count
        .elseif count==48
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D25             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,2094
                mov wordout,12
                inc count
        .elseif count==49
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D26             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,2106
                mov wordout,46
                inc count
        .elseif count==50
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D27             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2152
                mov wordout,67
                inc count
        .elseif count==51
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D28             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,2219
                mov wordout,31
                inc count
        .elseif count==52
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D29             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2250
                mov wordout,27
                inc count
        .elseif count==53
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D210             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2277
                mov wordout,31
                inc count
        .elseif count==54
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D211             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,2308
                mov wordout,42
                inc count
        .elseif count==55
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D212             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,2350
                mov wordout,14
                inc count
        .elseif count==56
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D212             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2364
                mov wordout,31
                inc count
        .elseif count==57
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D212             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2395
                mov wordout,50
                inc count
        .elseif count==58
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D213             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,2445
                mov wordout,10
                inc count
        .elseif count==59
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2455
                mov wordout,56
                inc count
        .elseif count==60
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2511
                mov wordout,41
                inc count
        .elseif count==61
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D215            ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2552
                mov wordout,17
                inc count
        .elseif count==62
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2569
                mov wordout,62
                inc count
        .elseif count==63
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D213             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,2631
                mov wordout,12
                inc count
        .elseif count==64
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2643
                mov wordout,39
                inc count
        .elseif count==65
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D215             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2682
                mov wordout,26
                inc count
        .elseif count==66
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2708
                mov wordout,45
                inc count
        .elseif count==67
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D215             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2753
                mov wordout,20
                inc count
        .elseif count==68
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2773
                mov wordout,70
                inc count
        .elseif count==69
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D215             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,2843
                mov wordout,75
                mov keyin,1
        .elseif count==70

        .elseif count==71

        .elseif count==72
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3063
                mov wordout,10
                inc count
        .elseif count==73
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D21             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3073
                mov wordout,10
                inc count
        .elseif count==74
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D31             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3083
                mov wordout,75
                inc count
        .elseif count==75
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D30             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3158
                mov wordout,11
                inc count
        .elseif count==76
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D32             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3169
                mov wordout,9
                inc count
        .elseif count==77
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D33             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3178
                mov wordout,64
                inc count
        .elseif count==78
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D32             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3242
                mov wordout,46
                inc count
        .elseif count==79
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D33             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3288
                mov wordout,72
                inc count
        .elseif count==80
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D32             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3360
                mov wordout,62
                inc count
        .elseif count==81
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D33             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3422
                mov wordout,58
                inc count
        .elseif count==82
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D33             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3480
                mov wordout,71
                inc count
        .elseif count==83
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D32             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3551
                mov wordout,18
                inc count
        .elseif count==84
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D33             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3569
                mov wordout,33
                inc count
        .elseif count==85
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D32             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3602
                mov wordout,7
                inc count
        .elseif count==86
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3609
                mov wordout,8
                inc count
        .elseif count==87
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3617
                mov wordout,12
                inc count
        .elseif count==88
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3629
                mov wordout,51
                inc count
        .elseif count==89
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D335             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3680
                mov wordout,28
                inc count
        .elseif count==90
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D335             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3708
                mov wordout,44
                inc count
        .elseif count==91
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D115             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3752
                mov wordout,12
                inc count
        .elseif count==92
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D35             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3764
                mov wordout,88
                inc count
        .elseif count==93
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D34             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3852
                mov wordout,11
                inc count
        .elseif count==94
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D345             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,3863
                mov wordout,12
                inc count
        .elseif count==95
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3875
                mov wordout,30
                inc count
        .elseif count==96
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3905
                mov wordout,21
                inc count
        .elseif count==97
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,3926
                mov wordout,72
                inc count
        .elseif count==98
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,3998
                mov wordout,67
                mov keyin,1
        .elseif count==99

        .elseif count==100
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4105
                mov wordout,27
                inc count
        .elseif count==101
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4132
                mov wordout,15
                inc count
        .elseif count==102
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4147
                mov wordout,86
                mov keyin,1
        .elseif count==103

        .elseif count==104

        .elseif count==105
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4322
                mov wordout,47
                add count,2
        .elseif count==106
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4369
                mov wordout,17
                inc count
        .elseif count==107
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4386
                mov wordout,29
                inc count
        .elseif count==108
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D36             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4415
                mov wordout,11
                inc count
        .elseif count==109
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,4426
                mov wordout,10
                inc count
        .elseif count==110
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,4436
                mov wordout,12
                inc count
        .elseif count==111
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D40             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4448
                mov wordout,99
                mov keyin,1
        .elseif count==112

        .elseif count==113
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D45             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4578
                mov wordout,119
                mov keyin,1
        .elseif count==114

        .elseif count==115

        .elseif count==116

        .elseif count==117
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D41             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4841
                mov wordout,24
                inc count
        .elseif count==118
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D42             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,4865
                mov wordout,33
                inc count
        .elseif count==119
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D42            ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,4898
                mov wordout,63
                inc count
        .elseif count==120
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D41             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,4961
                mov wordout,36
                inc count
        .elseif count==121
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D42             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,4997
                mov wordout,57
                inc count
        .elseif count==122
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D41             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5054
                mov wordout,66
                mov keyin,1
        .elseif count==123

        .elseif count==124
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D43             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5130
                mov wordout,14
                inc count
        .elseif count==125
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5144
                mov wordout,19
                inc count
        .elseif count==126
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D43             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5163
                mov wordout,45
                mov keyin,1
        .elseif count==127

        .elseif count==128
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D43             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5235
                mov wordout,32
                inc count
        .elseif count==129
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5267
                mov wordout,31
                inc count
        .elseif count==130
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5298
                mov wordout,50
                inc count
        .elseif count==131
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,5348
                mov wordout,17
                inc count
        .elseif count==132
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,5365
                mov wordout,59
                inc count
        .elseif count==133
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5424
                mov wordout,65
                mov keyin,1
        .elseif count==134

        .elseif count==135
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5581
                mov wordout,35
                mov keyin,1
        .elseif count==136

        .elseif count==137

        .elseif count==138

        .elseif count==139
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D111             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,5730
                mov wordout,48
                inc count
        .elseif count==140
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D19             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,5778
                mov wordout,40
                inc count
        .elseif count==141
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D110             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5818
                mov wordout,62
                mov keyin,1
        .elseif count==142

        .elseif count==143
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D410             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,5904
                mov wordout,80
                mov keyin,1
        .elseif count==144

        .elseif count==145

        .elseif count==146
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D25             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6049
                mov wordout,12
                inc count
        .elseif count==147
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6061
                mov wordout,8
                inc count
        .elseif count==148
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D410             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6069
                mov wordout,29
                inc count
        .elseif count==149
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6098
                mov wordout,40
                inc count
        .elseif count==150
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D410             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6138
                mov wordout,44
                mov keyin,1
        .elseif count==151

        .elseif count==152
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D410             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6210
                mov wordout,52
                mov keyin,1
        .elseif count==153

        .elseif count==154
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6274
                mov wordout,10
                inc count
        .elseif count==155
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6284
                mov wordout,8
                inc count
        .elseif count==156
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D40            ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6292
                mov wordout,33
                inc count
        .elseif count==157
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6325
                mov wordout,14
                inc count
        .elseif count==158
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6339
                mov wordout,14
                inc count
        .elseif count==159
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6353
                mov wordout,43
                inc count
        .elseif count==160
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,6396
                mov wordout,66
                inc count
        .elseif count==161
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6462
                mov wordout,53
                mov keyin,1
        .elseif count==162

        .elseif count==163
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6522
                mov wordout,22
                inc count
        .elseif count==164
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6544
                mov wordout,53
                inc count
        .elseif count==165
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6597
                mov wordout,42
                inc count
        .elseif count==166
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6639
                mov wordout,10
                inc count
        .elseif count==167
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6649
                mov wordout,14
                inc count
        .elseif count==168
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6663
                mov wordout,10
                inc count
        .elseif count==169
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6673
                mov wordout,80
                mov keyin,1
        .elseif count==170

        .elseif count==171

        .elseif count==172
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6814
                mov wordout,14
                inc count
        .elseif count==173
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6828
                mov wordout,30
                inc count
        .elseif count==174
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6858
                mov wordout,37
                inc count
        .elseif count==175
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6895
                mov wordout,35
                inc count
        .elseif count==176
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6930
                mov wordout,15
                inc count
        .elseif count==177
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6945
                mov wordout,23
                inc count
        .elseif count==178
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6968
                mov wordout,31
                inc count
        .elseif count==179
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6999
                mov wordout,11
                inc count
        .elseif count==180
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D21             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,7010
                mov wordout,24
                inc count
        .elseif count==181
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D31             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7034
                mov wordout,82
                mov keyin,1
        .elseif count==182

        .elseif count==183
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7164
                mov wordout,19
                inc count
        .elseif count==184
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7183
                mov wordout,35
                inc count
        .elseif count==185
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7218
                mov wordout,48
                inc count
        .elseif count==186
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7266
                mov wordout,89
                mov keyin,1
        .elseif count==187

        .elseif count==188

        .elseif count==189
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7438
                mov wordout,60
                add count,2
        .elseif count==190
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7498
                mov wordout,17
                inc count
        .elseif count==191
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,7515
                mov wordout,10
                inc count
        .elseif count==192
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54            ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,7525
                mov wordout,29
                inc count
        .elseif count==193
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D53             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7554
                mov wordout,49
                mov count,196
        .elseif count==194
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D53             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7603
                mov wordout,49
                inc count
        .elseif count==195
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D53             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7652
                mov wordout,49
                inc count
        .elseif count==196
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,7701
                mov wordout,38
                inc count
        .elseif count==197
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D53            ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7739
                mov wordout,7
                inc count
        .elseif count==198
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7746
                mov wordout,27
                inc count
        .elseif count==199
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,7773
                mov wordout,50
                inc count
        .elseif count==200
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,7823
                mov wordout,8
                inc count
        .elseif count==201
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D40             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7831
                mov wordout,82
                mov keyin,1
        .elseif count==202

        .elseif count==203
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,7920
                mov wordout,14
                inc count
        .elseif count==204
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7934
                mov wordout,91
                inc count
        .elseif count==205
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8025
                mov wordout,97
                mov keyin,1
        .elseif count==206

        .elseif count==207

        .elseif count==208
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D60             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8178
                mov wordout,12
                inc count
        .elseif count==209
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D61             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8190
                mov wordout,15
                inc count
        .elseif count==210
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D61             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8205
                mov wordout,31
                inc count
        .elseif count==211
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D62             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8236
                mov wordout,52
                inc count
        .elseif count==212
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D61             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8288
                mov wordout,19
                inc count
        .elseif count==213
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D63             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8307
                mov wordout,10
                inc count
        .elseif count==214
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8317
                mov wordout,11
                inc count
        .elseif count==215
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8328
                mov wordout,30
                mov keyin,1
        .elseif count==216

        .elseif count==217

        .elseif count==218
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8488
                mov wordout,32
                add count,2
        .elseif count==219
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8520
                mov wordout,29
                inc count
        .elseif count==220
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D66             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8549
                mov wordout,14
                inc count
        .elseif count==221
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D67             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8563
                mov wordout,15
                inc count
        .elseif count==222
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D68             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8578
                mov wordout,8
                inc count
        .elseif count==223
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D69             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8586
                mov wordout,12
                inc count
        .elseif count==224
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D610             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8598
                mov wordout,42
                inc count
        .elseif count==225
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D611             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8640
                mov wordout,14
                inc count
        .elseif count==226
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D610             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8654
                mov wordout,22
                inc count
        .elseif count==227
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D69             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8676
                mov wordout,44
                inc count
        .elseif count==228
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D611             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8720
                mov wordout,16
                inc count
        .elseif count==229
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D610             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8736
                mov wordout,24
                inc count
        .elseif count==230
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D633             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8760
                mov wordout,12
                inc count
        .elseif count==231
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8772
                mov wordout,42
                inc count
        .elseif count==232
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,8814
                mov wordout,34
                inc count
        .elseif count==233
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8848
                mov wordout,22
                inc count
        .elseif count==234
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8870
                mov wordout,47
                inc count
        .elseif count==235
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8917
                mov wordout,6
                inc count
        .elseif count==236
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D65             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,8923
                mov wordout,20
                inc count
        .elseif count==237
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8943
                mov wordout,36
                inc count
        .elseif count==238
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8979
                mov wordout,18
                mov count,248
        .elseif count==239
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8997
                mov wordout,26
                inc count
        .elseif count==240
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9023
                mov wordout,14
                inc count
        .elseif count==241
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9037
                mov wordout,47
                inc count
        .elseif count==242
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9084
                mov wordout,20
                mov count,248
        .elseif count==243
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9104
                mov wordout,33
                inc count
        .elseif count==244
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9137
                mov wordout,71
                inc count
        .elseif count==245
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9208
                mov wordout,19
                inc count
        .elseif count==246
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9227
                mov wordout,36
                inc count
        .elseif count==247
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9263
                mov wordout,17
                inc count
        .elseif count==248
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9280
                mov wordout,10
                inc count
        .elseif count==249
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9290
                mov wordout,42
                mov count,252
        .elseif count==250
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9332
                mov wordout,42
                inc count
        .elseif count==251
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9374
                mov wordout,42
                inc count
        .elseif count==252
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D54             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9416
                mov wordout,24
                inc count
        .elseif count==253
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D53             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9440
                mov wordout,34
                inc count
        .elseif count==254
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset BMPName             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9474
                mov wordout,8
                inc count
        .elseif count==255
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D13             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9482
                mov wordout,24
                inc count
        .elseif count==256
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D13             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9506
                mov wordout,21
                inc count
        .elseif count==257
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9527
                mov wordout,8
                inc count
        .elseif count==258
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D40             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9535
                mov wordout,26
                inc count
        .elseif count==259
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9561
                mov wordout,10
                inc count
        .elseif count==260
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9571
                mov wordout,51
                inc count
        .elseif count==261
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,9622
                mov wordout,20
                inc count
        .elseif count==262
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9642
                mov wordout,6
                inc count
        .elseif count==263
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D472             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9648
                mov wordout,26
                inc count
        .elseif count==264
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D471             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9674
                mov wordout,49
                mov keyin,1
        .elseif count==265

        .elseif count==266
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9749
                mov wordout,18
                inc count
        .elseif count==267
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9767
                mov wordout,34
                inc count
        .elseif count==268
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9801
                mov wordout,37
                inc count
        .elseif count==269
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9838
                mov wordout,27
                inc count
        .elseif count==270
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9865
                mov wordout,29
                inc count
        .elseif count==271
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D14             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9894
                mov wordout,8
                inc count
        .elseif count==272
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9902
                mov wordout,8
                inc count
        .elseif count==273
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D21             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,9910
                mov wordout,8
                inc count
        .elseif count==274
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D31             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9918
                mov wordout,22
                inc count
        .elseif count==275
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D31             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9940
                mov wordout,54
                mov keyin,1
        .elseif count==276

        .elseif count==277
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10031
                mov wordout,72
                mov keyin,1
        .elseif count==278

        .elseif count==279

        .elseif count==280
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10216
                mov wordout,50
                add count,2
        .elseif count==281
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D476             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10266
                mov wordout,30
                inc count
        .elseif count==282
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D118             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,10296
                mov wordout,10
                inc count
        .elseif count==283
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10306
                mov wordout,12
                inc count
        .elseif count==284
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10318
                mov wordout,7
                inc count
        .elseif count==285
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10325
                mov wordout,23
                inc count
        .elseif count==286
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10348
                mov wordout,43
                inc count
        .elseif count==287
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10391
                mov wordout,20
                inc count
        .elseif count==288
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10411
                mov wordout,9
                inc count
        .elseif count==289
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10420
                mov wordout,60
                inc count
        .elseif count==290
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10480
                mov wordout,6
                inc count
        .elseif count==291
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10486
                mov wordout,64
                inc count
        .elseif count==292
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10550
                mov wordout,44
                inc count
        .elseif count==293
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D83             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,4
                mov wordnumber,10594
                mov wordout,37
                inc count
        .elseif count==294
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D81             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10631
                mov wordout,12
                inc count
        .elseif count==295
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D84             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10643
                mov wordout,53
                inc count
        .elseif count==296
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset d8             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10696
                mov wordout,32
                inc count
        .elseif count==297
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D82             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10728
                mov wordout,18
                inc count
        .elseif count==298
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset d8             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10746
                mov wordout,28
                inc count
        .elseif count==299
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D82             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10774
                mov wordout,22
                inc count
        .elseif count==300
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D82             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10796
                mov wordout,50
                inc count
        .elseif count==301
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset d8             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,10846
                mov wordout,12
                inc count
        .elseif count==302
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D212             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,10858
                mov wordout,22
                inc count
        .elseif count==303
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset d888             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,10880
                mov wordout,21
                inc count
        .endif

        .if     peoplenow==0
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character0,hWnd
        .elseif peoplenow==1
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character1,hWnd
        .elseif peoplenow==2
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character2,hWnd
        .elseif peoplenow==3
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character3,hWnd
        .elseif peoplenow==4
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character4,hWnd
        .elseif peoplenow==10
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character10,hWnd
        .endif
        mov switchh,1


.elseif uMsg==WM_TIMER
        .if switchh==1
            mov ecx,beenwritten
            .if ecx<=wordout
                invoke  InvalidateRect,hWnd,ADDR wordspace,1
                invoke  DrawStr,offset buffer,hWnd
                inc beenwritten
            .else
                mov switchh,0
                mov beenwritten,1
            .endif
        .endif
.elseif uMsg==WM_KEYUP
        .if wParam==31h
            .if count==36
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1751
                mov wordout,50
                mov count,39
            .elseif count==69
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2918
                mov wordout,71
                mov count,72
            .elseif count==98
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4065
                mov wordout,40
                mov count,100
            .elseif count==102
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4233
                mov wordout,59
                mov count,105
            .elseif count==111
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D46             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4547
                mov wordout,31
                mov count,113
            .elseif count==113
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D46             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4697
                mov wordout,61
                mov count,131
            .elseif count==122
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,5348
                mov wordout,17
                mov count,132
            .elseif count==126
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5208
                mov wordout,27
                mov count,128
            .elseif count==133
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,5489
                mov wordout,92
                mov count,135
            .elseif count==135
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,5616
                mov wordout,28
                mov count,146
            .elseif count==141
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D25             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6049
                mov wordout,12
                mov count,147
            .elseif count==143
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5984
                mov wordout,33
                mov count,146
            .elseif count==150
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6182
                mov wordout,28
                mov count,152
            .elseif count==152
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6262
                mov wordout,12
                mov count,154
            .elseif count==161
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,6515
                mov wordout,7
                mov count,163
            .elseif count==169
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6753
                mov wordout,26
                mov count,172
            .elseif count==181
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7116
                mov wordout,48
                mov count,183
            .elseif count==186
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7355
                mov wordout,48
                mov count,189
            .elseif count==201
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7913
                mov wordout,7
                mov count,203
            .elseif count==205
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8122
                mov wordout,29
                mov count,208
            .elseif count==215
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8358
                mov wordout,65
                mov count,218
            .elseif count==264
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D51             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,0
                mov wordnumber,9723
                mov wordout,26
                mov count,266
            .elseif count==275
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,9994
                mov wordout,37
                mov count,277
            .elseif count==277
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10103
                mov wordout,47
                mov count,280
            .endif
        .elseif wParam==32h
            .if count==36
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D116             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,1801
                mov wordout,38
                mov count,39
            .elseif count==69
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D214             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,2989
                mov wordout,74
                mov count,72
            .elseif count==98
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4065
                mov wordout,40
                mov count,100
            .elseif count==102
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4233
                mov wordout,59
                mov count,105
            .elseif count==111
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D42             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,4803
                mov wordout,38
                mov count,117
            .elseif count==113
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D46             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4758
                mov wordout,45
                mov count,131
            .elseif count==122
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D18             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,5348
                mov wordout,17
                mov count,132
            .elseif count==126
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5208
                mov wordout,27
                mov count,128
            .elseif count==133
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D19             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,1
                mov wordnumber,5681
                mov wordout,49
                mov count,139
            .elseif count==135
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,5644
                mov wordout,37
                mov count,146
            .elseif count==141
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D25             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,10
                mov wordnumber,6049
                mov wordout,12
                mov count,147
            .elseif count==143
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6017
                mov wordout,32
                mov count,146
            .elseif count==150
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6182
                mov wordout,28
                mov count,152
            .elseif count==152
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,6262
                mov wordout,12
                mov count,154
            .elseif count==161

            .elseif count==169
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,6779
                mov wordout,35
                mov count,172
            .elseif count==181
invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
            .elseif count==186
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,7403
                mov wordout,35
                mov count,190
            .elseif count==201

            .elseif count==205
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D52             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8151
                mov wordout,27
                mov count,239
            .elseif count==215
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D64             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,8423
                mov wordout,65
                mov count,219
            .elseif count==264

            .elseif count==275

            .elseif count==277
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D475             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,10150
                mov wordout,66
                mov count,281
            .endif
        .elseif wParam==33h
            .if count==102
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D37             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,3
                mov wordnumber,4292
                mov wordout,30
                mov count,106
            .elseif count==111
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D44             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5120
                mov wordout,10
                mov count,124
            .elseif count==133
                invoke  InvalidateRect,hWnd,ADDR picturespace,1
                invoke  LoadBitmap,hInstance,offset D49             ;078 載入位元圖
                mov     hBitmap,eax
                invoke  UpdateWindow,hwnd
                mov peoplenow,2
                mov wordnumber,5880
                mov wordout,24
                mov count,143
            .elseif count==161

            .elseif count==181

            .elseif count==201

            .elseif count==264

            .elseif count==275

            .endif
        .elseif wParam==34h
            .if count==181

            .endif
        .elseif wParam==30h
            add count,-5
        .elseif wParam==39h
            mov count,283
        .elseif wParam==38h
            add count,5
        .endif
        .if keyin==1
            .if     peoplenow==0
                invoke  InvalidateRect,hWnd,ADDR namespace,1
                invoke  DrawStr1,offset character0,hWnd
            .elseif peoplenow==1
                    invoke  InvalidateRect,hWnd,ADDR namespace,1
                    invoke  DrawStr1,offset character1,hWnd
            .elseif peoplenow==2
                    invoke  InvalidateRect,hWnd,ADDR namespace,1
                    invoke  DrawStr1,offset character2,hWnd
            .elseif peoplenow==3
                    invoke  InvalidateRect,hWnd,ADDR namespace,1
                    invoke  DrawStr1,offset character3,hWnd
            .elseif peoplenow==4
                    invoke  InvalidateRect,hWnd,ADDR namespace,1
                    invoke  DrawStr1,offset character4,hWnd
            .elseif peoplenow==10
                    invoke  InvalidateRect,hWnd,ADDR namespace,1
                    invoke  DrawStr1,offset character10,hWnd
            .endif
            mov switchh,1
            .if wParam==31h
                mov keyin,0
            .elseif wParam==32h
                mov keyin,0
            .elseif wParam==33h
                mov keyin,0
            .endif
        .endif

.elseif uMsg==WM_CLOSE
exit:   invoke  DestroyWindow,hWnd

.elseif uMsg==WM_DESTROY
        invoke  PostQuitMessage,NULL

.else
def:    invoke  DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
.endif
        xor     eax,eax
        ret
WndProc endp

DrawStr proc    AddrSt:DWORD,hWin:DWORD ;83 DrawStr 副程式開始
        LOCAL   hDevCont:HDC            ;84 區域變數，存 DC 代碼
        LOCAL   PS:PAINTSTRUCT          ;85 區域變數，存
        LOCAL   rectagl:RECT            ;86
        invoke  BeginPaint,hWin,ADDR PS ;87

        mov     hDevCont,eax            ;88
        invoke  SetTextColor,hDevCont,0ffffffh
        invoke  SetBkColor,hDevCont,fieldbkcolor
        invoke  SelectObject,hDevCont,magicfont
        mov     ecx,AddrSt
        add     ecx,wordnumber
        mov     AddrSt,ecx
        mov     ecx,beenwritten
        invoke  DrawText,hDevCont,AddrSt,ecx,\   ;90
                ADDR wordspace,DT_WORDBREAK or DT_LEFT   ;91
        invoke  EndPaint,hWin,ADDR PS           ;92
        ret
DrawStr endp


DrawStr1 proc    AddrSt:DWORD,hWin:DWORD ;83 DrawStr 副程式開始
        LOCAL   hDevCont:HDC            ;84 區域變數，存 DC 代碼
        LOCAL   PS:PAINTSTRUCT          ;85 區域變數，存
        LOCAL   rectagl:RECT            ;86

        invoke  BeginPaint,hWin,ADDR PS ;87

        mov     hDevCont,eax            ;88
        invoke  SetTextColor,hDevCont,0ffffffh
        invoke  SetBkColor,hDevCont,fieldbkcolor
        invoke  SelectObject,hDevCont,magicfont
        invoke  DrawText,hDevCont,AddrSt,-1,\   ;90
                ADDR namespace,DT_WORDBREAK or DT_CENTER   ;91
        invoke  EndPaint,hWin,ADDR PS           ;92
        ret
DrawStr1 endp
;-----------------------------------------------------------
;***********************************************************
end     start
