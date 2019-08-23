function genotype=ctrlname(driver,effector)
if strcmp(effector,'UAS_TNT_lexAop_Chrimson_attp18_72F11_lexA')
    genotype='attp2@UAS_TNT_lexAop_Chrimson_attp18_72F11_lexA'; 
    % strcat(driver,'@UAS_impTNT_lexAop_Chrimson_attp18_72F11_lexA')
    % 'attp2@UAS_TNT_lexAop_Chrimson_attp18_72F11_lexA'
%'attp2@',effector,'@t93@'  'E:\back_up\matlab\matlab_data\attp2@UAS_Chrimson_attp18_72F11_6hfed'
% elseif contains(effector,'lexA_lexAop_KZ')
%     genotype=strcat(driver,'@',strcat(effector(1:strfind(effector,'_attp18')+7),...
%         effector(strfind(effector,'lexAop_KZ'):end)));  %modify for KZ
elseif contains(effector,'_AITC')
    genotype=strcat(driver,'@',effector(1:strfind(effector,'_AITC')-1));
elseif contains(effector,'fed')
    genotype=strcat(driver,'@',strcat(effector(1:strfind(effector,'fed')-1),'before'));
elseif contains(effector,'starved')
    genotype=strcat(driver,'@',strcat(effector(1:strfind(effector,'starved')-1),'fed'));
elseif strcmp(effector,'UAS_Chrimsonattp18_72F11')
    genotype=strcat('FCF_attP2_1500062@UAS_Chrimsonattp18_72F11');
elseif strcmp(driver,'GMR_69F06')&strcmp(effector,'UAS_Chrimson_db')
    genotype='GMR_69F06@UAS_Chrimson';
else
    genotype=strcat('attp2@',effector);
    % genotype='GMR_SS04185@UAS_Chrimson'
end 
disp(strcat('control=',genotype));
end