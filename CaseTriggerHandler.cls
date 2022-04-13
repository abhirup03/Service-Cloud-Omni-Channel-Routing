public with sharing class CaseTriggerHandler {



//Create PSR and add Skill to a WorkItem
Public static void CreatePSRandSkill(List<Id> caseRecords){

List<Case> cases = new List<Case>([select id from case where Id IN: caseRecords]);
system.debug('case id---'+cases);

List<PendingServiceRouting> CreatePSRList = new List<PendingServiceRouting>();


for(integer i=0; i<cases.size(); i++){
	
    PendingServiceRouting psrObj = new PendingServiceRouting();
    psrObj.CapacityWeight = 1;
    psrObj.IsReadyForRouting = false;
    psrObj.RoutingModel = 'MostAvailable';
    psrObj.RoutingPriority = 1;
    psrObj.ServiceChannelId = '0N97F000000Li8o';
    psrObj.WorkItemId = cases[i].id;
    psrObj.PushTimeout = 0;
    psrObj.RoutingType = 'SkillsBased';

    CreatePSRList.add(psrObj);
}        

if(CreatePSRList.size()>0 && CreatePSRList!=null){
    Insert CreatePSRList;
    system.debug('PSR created---'+CreatePSRList);
}

List<Id> PSRCreated = new List<Id>();

for(integer p=0; p<CreatePSRList.size(); p++){
    PSRCreated.add(CreatePSRList[p].id);     
}

//Call future method to add SkillRequirement
CaseTriggerHandler.createSkillRequirement(PSRCreated);

}

@future(callout=true)
public static void createSkillRequirement(List<Id> PSRId){
system.debug('PSR ID line 95---'+PSRId);

String receivedPSRId;

for(Id x: PSRId){
    receivedPSRId = x;
    break;
}        
system.debug('receivedPSRId ==='+receivedPSRId);

List<PendingServiceRouting> obj = new List<PendingServiceRouting>(
    [select id from PendingServiceRouting where id=:receivedPSRId and isReadyForRouting=false]
);
system.debug('obj line 102---'+obj);



//Add SkillRequirement Object

List<SkillRequirement> SkillReq = new List<SkillRequirement>();

for(Integer j=0; j<obj.size(); j++){
    SkillRequirement Skills = new SkillRequirement();
    Skills.IsAdditionalSkill = false; 
    Skills.RelatedRecordId = obj[j].id;
    Skills.SkillId = '0C57F000000PFK7SAO';
    SkillReq.add(Skills);
    system.debug('skill record is---'+SkillReq);
}

if(SkillReq.size()>0 && SkillReq!=null){
    insert SkillReq;
    system.debug('SkillRequirement created---'+SkillReq);
}

//Once the Skills are inserted, set isReadyForRouting to true in the PSR. 

List<PendingServiceRouting> finalPSRUpdate = new List<PendingServiceRouting>();

if(obj.size()>0 && obj!=null){
    for(PendingServiceRouting psr: obj){
	psr.IsReadyForRouting = true;
	finalPSRUpdate.add(psr);
    }
    if(finalPSRUpdate.size()>0 && finalPSRUpdate!=null){
	update finalPSRUpdate;
	system.debug('finally updated psr values ----'+finalPSRUpdate);
    }
}

}
}
