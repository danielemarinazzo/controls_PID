function output = sPID(data,id1,id2,it)
%function [RED, SYN, II, MI1, MI2, U1, U2]= sPID(data,id1,id2,it)
%id1 and id2 drivers index, it target index
data=copnorm(data);
t=data(:,it);d1=data(:,id1);d2=data(:,id2);
JMI=mi_gg(t,[d1 d2]);
MI1=mi_gg(t,d1);
MI2=mi_gg(t,d2);
RED=min(MI1,MI2); % define the redundancy as minumum of the two MI terms
U1=MI1-RED;
U2=MI2-RED;
SYN=JMI-RED-U1-U2;
II=JMI-MI1-MI2;
CMI12_T=cmi_ggg(d1,d2,t);
CMI1T_2=cmi_ggg(d1,t,d2);
CMI2T_1=cmi_ggg(d2,t,d1);
output(1)=RED;
output(2)=SYN;
output(3)=II;
output(4)=MI1;
output(5)=MI2;
output(6)=U1;
output(7)=U2;
output(8)=CMI12_T;
output(9)=CMI1T_2;
output(10)=CMI2T_1;