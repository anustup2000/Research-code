% %mode1=[1560.2844,1576.6764,1593.6405,1610.1563];
% mode1=[1559.4094,1575.5015,1593.0902,1609.941];
% mode2=[1564.2601,1580.2293,1596.6465,1613.1412];
% mode3=[1565.9106,1582.6165,1599.2709,1616.2137];
% %mode4=[1553.5373,1569.5708,1585.93,1602.4998,1619.3013];
% mode4=[1569.5708,1585.93,1602.4998,1619.3013];
% c=3*(10^8);
% mode1v=(c./mode1)*(10^9);
% mode2v=(c./mode2)*(10^9);
% mode3v=(c./mode3)*(10^9);
% mode4v=(c./mode4)*(10^9);
% x1=linspace(1,4,4);
% x2=linspace(1,4,4);
% x3=linspace(1,4,4);
% % x4=linspace(1,5,5);
% x4=linspace(1,4,4);
% dmode1=[(mode1(2)-mode1(1)),(mode1(3)-mode1(2)),(mode1(4)-mode1(3))];
% dmode2=[(mode2(2)-mode2(1)),(mode2(3)-mode2(2)),(mode2(4)-mode2(3))];
% dmode3=[(mode3(2)-mode3(1)),(mode3(3)-mode3(2)),(mode3(4)-mode3(3))];
% dmode4=[(mode4(2)-mode4(1)),(mode4(3)-mode4(2)),(mode4(4)-mode4(3))];
% % subplot(2,2,1)
% % plot(x1,mode1v,'-o',x2,mode2v,'-o',x3,mode3v,'-o',x4,mode4v,'-o')
% % subplot(2,2,2)
% % plot(x2,mode2)
% % subplot(2,2,3)
% % plot(x3,mode3)
% % subplot(2,2,4)
% % plot(x4,mode4)
% plot(mode1(2:4),dmode1,'-o',mode2(2:4),dmode2,'-o',mode3(2:4),dmode3,'-o',mode4(2:4),dmode4,'-o')

mode1=[1408.5,1393.9,1379.6,1365.7];
mode4=[];