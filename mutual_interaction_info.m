function [II, MI12, MI13, MI23, CMI12_3, CMI13_2, CMI23_1] = mutual_interaction_info(data,id1,id2,id3)
data=copnorm(data);
d3=data(:,id3);d1=data(:,id1);d2=data(:,id2);
JMI=mi_gg(d3,[d1 d2]);
MI12=mi_gg(d1,d2);
MI13=mi_gg(d1,d3);
MI23=mi_gg(d2,d3);
II=JMI-MI13-MI23;
CMI12_3=cmi_ggg(d1,d2,d3);
CMI13_2=cmi_ggg(d1,d3,d2);
CMI23_1=cmi_ggg(d2,d3,d1);