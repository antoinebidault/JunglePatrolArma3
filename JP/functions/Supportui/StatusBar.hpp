class StatusBar
{
    idd = 1766;
    onLoad = "uiNamespace setVariable ['StatusBar', _this select 0];";
    movingenable = false;
    duration = 10e10;

    class Controls
    {
        class StatusBarContent: RscStructuredText
        {
                idc = 1767;
                x = 0.914267 * safezoneW + safezoneX;
                y = 0.81033 * safezoneH + safezoneY;
                w = 0.0752567 * safezoneW;
                h = 0.0470196 * safezoneH;
                style = 16;
        };
    };
};

class RscStatusBar
{
        idd = -1;
        duration = 10e10;
        onLoad = "uiNamespace setVariable ['RscStatusBar', _this select 0];";
        fadein = 0;
        fadeout = 0;
        movingEnable = 0;
        objects[] = {};

      
 
        class controls
        {
                class statusBarText
                {
                        idc = 55554;
                        x =  "safeZoneX + safeZoneW - .3";
                        y = "0.7 * safeZoneW";
                        w = "0.105257 * safezoneW";
                        h = "0.025 * safezoneH";
                        shadow = 2;
                        size = 0.040;
                        type = 13;
                        style = 2;
                        text = "";
 
                        class Attributes
                        {
                                align="center";
                                color = "#ffffff";
                        };
                };
        };
};

class RscCompoundStatus
{
        idd = -1;
        duration = 10e10;
        onLoad = "uiNamespace setVariable ['RscCompoundStatus', _this select 0];";
        fadein = 0;
        fadeout = 0;
        movingEnable = 0;
        objects[] = {};

      
 
        class controls
        {
                class statusBarText
                {
                        idc = 55222;
                        x = "safezoneX + safezoneW * 0.7";
                        y = "safezoneY + safezoneH * 0.4";
                        w = "0.22 * safezoneW";
                        h = "0.104761 * safezoneH";
                        shadow = 2;
                        size = 0.030;
                        type = 13;
                        style = 2;
                        text = "";
 
                        class Attributes
                        {
                                align="right";
                                color = "#ffffff";
                        };
                };
        };
};
