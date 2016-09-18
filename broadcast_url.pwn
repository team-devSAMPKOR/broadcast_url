#define FILTERSCRIPT
#include <a_samp>
#include <dini>


enum aInfo
{
	aURL[256]
}
new BangsongInfo[aInfo];


new bangon[MAX_PLAYERS];
new bangzoo[256];
public OnFilterScriptInit(){
	for(new i = 0; i < GetMaxPlayers(); i++){
		bangon[i]=0;
	}
	return 1;
}

public OnFilterScriptExit(){
	for(new i = 0; i < GetMaxPlayers(); i++){
		StopAudioStreamForPlayer(i);
	}
	return 1;
}

main()
{
}


public OnPlayerConnect(playerid)
{
	new string[20];
	format(string, sizeof(string), "bangsong.ini");
	if(dini_Exists(string)){
		strmid(BangsongInfo[aURL],dini_Get("bangsong.ini","URL"),0,strlen(dini_Get("bangsong.ini","URL")),255);
		PlayAudioStreamForPlayer(playerid,BangsongInfo[aURL]);
		bangon[playerid]=1;
	}
	else{
		bangon[playerid]=0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];
	new string[256];
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd,"/방송하기",true)==0){
		if(IsPlayerConnected(playerid)){
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
			idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!IsPlayerAdmin(playerid)){
				SendClientMessage(playerid, -1, "[도움] 어드민이 아닙니다.");
				return 1;
			}
			if(!strlen(result)){
				SendClientMessage(playerid, -1, "[도움] /방송하기 [주소]");
				return 1;
			}

			new bangg[20];
			format(bangg, sizeof(bangg), "bangsong.ini");
			if(dini_Exists(bangg))
			{
				dini_Set(bangg,"URL", result);
			}else{
				dini_Create(bangg);
				dini_Set(bangg,"URL", result);
			}
			new asdf[24];
			GetPlayerName(playerid, asdf, 24);
			format(string, sizeof(string), "[도움] %s(%d)님이 방송주소를 설정합니다.",asdf,playerid);
			SendClientMessageToAll(-1, string);
			format(string, sizeof(string), "%s",result);
			bangzoo = string;

			for(new i = 0; i < GetMaxPlayers(); i++){
				bangon[i]=1;
				PlayAudioStreamForPlayer(i,result);
			}
		}
		return 1;
	}

	if(strcmp(cmd,"/방송",true)==0){
		if(bangon[playerid] ==0){
			new bangg[20];
			format(bangg, sizeof(bangg), "bangsong.ini");
			if(dini_Exists(bangg)){
				strmid(BangsongInfo[aURL],dini_Get("bangsong.ini","URL"),0,strlen(dini_Get("bangsong.ini","URL")),255);
				StopAudioStreamForPlayer(playerid);
				PlayAudioStreamForPlayer(playerid,BangsongInfo[aURL]);
				SendClientMessage(playerid,-1,"[도움] 방송을 시작합니다.");
				bangon[playerid]=1;
			}else{
				SendClientMessage(playerid,-1,"[도움] 설정된 방송주소가 없습니다.");
			}
		}
		else if(bangon[playerid] ==1){
			StopAudioStreamForPlayer(playerid);
			bangon[playerid]=0;
			SendClientMessage(playerid,-1,"[도움] 방송을 중지합니다.");
		}
		return 1;
	}
	return 0;
}


stock strtok(const string[],&index,seperator=' ')
{
        new length = strlen(string);
        new offset = index;
        new result[256];
        while((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = string[index];
                index++;
        }
        result[index - offset] = EOS;
        if((index < length) && (string[index] == seperator))
                index++;
        return result;
}
