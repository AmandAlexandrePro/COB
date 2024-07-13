#include maps\_utility; 
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\toStaticCOB;

init()
{
    if(!isDefined(self.Menu) && !isDefined(self.Hud))
    {
        self.Menu = spawnStruct();
        self.Menu.Opened = false;
        self.Hud = spawnStruct();
        self thread _controls();
        self thread _destroyMenu();
    }
}

_controls()
{
    level endon("electricity_on");
    for(;;)
    {
        if(self.Menu.Opened)
        {
            if(!self toStaticCOB(self.Menu.CurrentMenu, "lock"))
            {
                if(self AdsButtonPressed())
                {
                    if(self.Menu.CurrentMenu == "treasure")
                        self _letterUpdate(0);
                    else
                        self _scrollUpdate(0);
                    wait .1;
                }
                if(self AttackButtonPressed())
                {
                    if(self.Menu.CurrentMenu == "treasure")
                        self _letterUpdate(1);
                    else
                        self _scrollUpdate(1);
                    wait .1;
                }
                if(self UseButtonPressed())
                {
                    if(self.Menu.CurrentMenu == "treasure")
                    {
                        if(isDefined(self.Hud.Input))
                        {
                            if(isString(level.letters[self.Letter]))
                            {
                                level toStaticCOB(self.Menu.CurrentMenu, "answer", level toStaticCOB(self.Menu.CurrentMenu, "answer") + level.letters[self.Letter] + " ");
                                self toStaticCOB(self.Menu.CurrentMenu, "answer", level toStaticCOB(self.Menu.CurrentMenu, "answer"));
                                if(level toStaticCOB(self.Menu.CurrentMenu, "answer") == "r e s p e c t ")
                                {
                                    level toStaticCOB(self.Menu.CurrentMenu, undefined, true);
                                    self toStaticCOB(self.Menu.CurrentMenu, "lock", true);
                                    self maps\_zombiemode_score::add_to_player_score(500);
				                    self playsound("cha_ching");
                                }
                                else
                                {
                                    if(Strtok(level toStaticCOB(self.Menu.CurrentMenu, "answer"), " ").size >= 7)
                                    {
                                        self.Hud.Input.color = (1,0,0);
                                        wait 2;
                                        level toStaticCOB(self.Menu.CurrentMenu, "answer", "");
                                        self toStaticCOB(self.Menu.CurrentMenu, "answer", level toStaticCOB(self.Menu.CurrentMenu, "answer"));
                                        self.Hud.Input.color = (1,1,1);
                                        self.Hud.Input setText(self toStaticCOB(self.Menu.CurrentMenu, "answer"));
                                    }
                                    else
                                    {
                                        self.Hud.Input setText(self toStaticCOB(self.Menu.CurrentMenu, "answer"));
                                    }
                                    self.Letter = 0;
                                    self _letterUpdate();
                                }
                            }
                        }
                    }
                    else
                    {
                        if(!isNumber(self toStaticCOB(self.Menu.CurrentMenu)))
                        {
                            self toStaticCOB(self.Menu.CurrentMenu, undefined, self toStaticCOB(self.Menu.CurrentMenu, "scroll"));
                            level toStaticCOB(self.Menu.CurrentMenu, undefined, (level toStaticCOB(self.Menu.CurrentMenu) + 1));
                            self toStaticCOB(self.Menu.CurrentMenu, "lock", true);
                        }
                    }
                    wait .3;
                }
            }
        }
        wait 0.05;
    }
}

loadMenu(menu, answered)
{
    if(isString(menu))
    {
        self.Menu.CurrentMenu = menu;
        self.Menu.Opened = true;
        self _destroyMenuText();
        if(!isDefined(self.Hud.Background))
            self.Hud.Background = createRectangle(400, undefined, .5);
        if(self.Menu.CurrentMenu == "treasure")
        {
            if(!isDefined(self.Hud.First))
                self.Hud.First = createText("Mon PRemier est un Ordre de ??? des réponses trouvées.", 65, "TOP", 2);
            if(!isDefined(self.Hud.Second))
                self.Hud.Second = createText("Mon deuxième est une Suite d'éléments dissimulées dans la carte.", 100, "TOP", 2);
            if(isNumber(level toStaticCOB(self.Menu.CurrentMenu)))
            {
                if(level toStaticCOB(self.Menu.CurrentMenu) >= 1 && level toStaticCOB(self.Menu.CurrentMenu) < 3)
                {
                    if(!isDefined(self.Hud.Third))
                        self.Hud.Third = createText("Mon tout est le Temps.", 140, "TOP", 2);
                    self thread _destroyTreasure();
                }
            }
            if(!isDefined(self.Hud.Controls))
                self.Hud.Controls = createText("[{+attack}] / [{+toggleads_throw}] pour Changer de Lettre | [{+activate}] pour Valider", -100, "BOTTOM", 1.5);
            else
                self.Hud.Controls setText("[{+attack}] / [{+toggleads_throw}] pour Changer de Lettre | [{+activate}] pour Valider");
            if(!isString(self toStaticCOB(self.Menu.CurrentMenu, "answer")))
                self toStaticCOB(self.Menu.CurrentMenu, "answer", "");
            if(!isString(level toStaticCOB(self.Menu.CurrentMenu, "answer")))
                level toStaticCOB(self.Menu.CurrentMenu, "answer", "");
            if(isDefined(answered))
            {
                if(!isDefined(self.Hud.Input))
                    self.Hud.Input = createText(self toStaticCOB(self.Menu.CurrentMenu, "answer"), undefined, undefined, 5, (0, 1, 0));
                else
                {
                    self.Hud.Input.color = (0, 1, 0);
                    self.Hud.Input setText(self toStaticCOB(self.Menu.CurrentMenu, "answer"));
                }
            }
            else
            {
                if(!isDefined(self.Hud.Input))
                    self.Hud.Input = createText(self toStaticCOB(self.Menu.CurrentMenu, "answer"), 45, undefined, 5);
                else
                {
                    self.Hud.Input.color = (1, 1, 1);
                    self.Hud.Input setText(self toStaticCOB(self.Menu.CurrentMenu, "answer"));
                }
                if(!isDefined(self.Hud.Letter))
                    self.Hud.Letter = createText("", -45, undefined, 5);
            }
            self _letterUpdate();
        }
        else if(isString(self.Menu.title[self.Menu.CurrentMenu]))
        {
            if(self.Menu.Text[self.Menu.CurrentMenu].size > 0)
            {
                if(isDefined(self.Hud.Title))
                    self.Hud.Title destroy();
                self.Hud.Title = createText(self.Menu.title[self.Menu.CurrentMenu], undefined, undefined, level toStaticCOB(self.Menu.CurrentMenu, "question_size"));
                for(i=0;i<self.Menu.Text[self.Menu.CurrentMenu].size;i++)
                {
                    self.Hud.Text[i] = createText(self.Menu.Text[self.Menu.CurrentMenu][i], (40 + (18 * i)), undefined, 1.5);
                }
                if(isNumber(level toStaticCOB(self.Menu.CurrentMenu)))
                {
                    if(level toStaticCOB(self.Menu.CurrentMenu) < 0 || level toStaticCOB(self.Menu.CurrentMenu) > getPlayers().size)
                        level toStaticCOB(self.Menu.CurrentMenu, 0);
                }
                else
                    level toStaticCOB(self.Menu.CurrentMenu, 0);
                if(isNumber(self toStaticCOB(self.Menu.CurrentMenu, "size")))
                {
                    if(self toStaticCOB(self.Menu.CurrentMenu, "size") != level toStaticCOB(self.Menu.CurrentMenu))
                        self toStaticCOB(self.Menu.CurrentMenu, "size", level toStaticCOB(self.Menu.CurrentMenu));
                }
                else
                    self toStaticCOB(self.Menu.CurrentMenu, "size", level toStaticCOB(self.Menu.CurrentMenu));
                if(!isDefined(self.Hud.Size))
                    self.Hud.Size = createText((self toStaticCOB(self.Menu.CurrentMenu, "size") + " / " + getPlayers().size), 20, undefined, 1.5);
                else
                    self.Hud.Size setText(self toStaticCOB(self.Menu.CurrentMenu, "size") + " / " + getPlayers().size);
                if(!isDefined(self.Hud.Controls))
                    self.Hud.Controls = createText("[{+attack}] / [{+toggleads_throw}] pour Naviguer | [{+activate}] pour Valider", -100, "BOTTOM", 1.5);
                else
                    self.Hud.Controls setText("[{+attack}] / [{+toggleads_throw}] pour Naviguer | [{+activate}] pour Valider");
                if(isDefined(answered))
                {
                    if(!isDefined(self.Hud.Scrollbar))
                        self.Hud.Scrollbar = createRectangle(20, 40, undefined, (0,1,0));
                    else
                        self.Hud.Scrollbar.color = (0,1,0);
                    if(isNumber(self toStaticCOB(self.Menu.CurrentMenu)))
                    {
                        if(self toStaticCOB(self.Menu.CurrentMenu, "scroll") != self toStaticCOB(self.Menu.CurrentMenu))
                            self toStaticCOB(self.Menu.CurrentMenu, "scroll", self toStaticCOB(self.Menu.CurrentMenu));
                    }
                }
                else
                {
                    if(!isDefined(self.Hud.Scrollbar))
                        self.Hud.Scrollbar = createRectangle(20, 40, undefined, (0,0,1));
                    else
                        self.Hud.Scrollbar.color = (0,0,1);
                }
                self _scrollUpdate();
            }
        }
    }
}

_scrollUpdate(method)
{
    if(self.Menu.CurrentMenu != "treasure" && isDefined(self.Hud.Scrollbar) && isDefined(self.Hud.Text))
    {
        if(isNumber(self toStaticCOB(self.Menu.CurrentMenu, "scroll")))
        {
            if(isNumber(method))
            {
                if(method > 0)
                    self toStaticCOB(self.Menu.CurrentMenu, "scroll", (self toStaticCOB(self.Menu.CurrentMenu, "scroll") + 1));
                else if(method < 1)
                    self toStaticCOB(self.Menu.CurrentMenu, "scroll", (self toStaticCOB(self.Menu.CurrentMenu, "scroll") - 1));
            }
            if(self toStaticCOB(self.Menu.CurrentMenu, "scroll") < 0)
                self toStaticCOB(self.Menu.CurrentMenu, "scroll", (self.Menu.Text[self.Menu.CurrentMenu].size - 1));
            else if(self toStaticCOB(self.Menu.CurrentMenu, "scroll") > (self.Menu.Text[self.Menu.CurrentMenu].size - 1))
                self toStaticCOB(self.Menu.CurrentMenu, "scroll", 0);
        }
        else
            self toStaticCOB(self.Menu.CurrentMenu, "scroll", 0);
        self.Hud.Scrollbar.y = 40 + (18 * self toStaticCOB(self.Menu.CurrentMenu, "scroll"));
    }
}

_letterUpdate(method)
{
    if(self.Menu.CurrentMenu == "treasure" && isDefined(self.Hud.Letter))
    {
        if(isNumber(self.Letter))
        {
            if(isNumber(method))
            {
                if(method > 0)
                    self.Letter ++;
                else if(method < 1)
                    self.Letter --;
            }
            if(self.Letter > (level.letters.size - 1))
                self.Letter = 0;
            if(self.Letter < 0)
                self.Letter = level.letters.size - 1;
        }
        else
            self.Letter = 0;
        textLetter = level.letters[self.Letter];
        if(isString(textLetter))
            self.Hud.Letter setText(textLetter);
    }
}

_destroyTreasure()
{
    if (level toStaticCOB(self.Menu.CurrentMenu) != 2)
    {
        level toStaticCOB(self.Menu.CurrentMenu, undefined, 2);
        wait 10;
        if (level toStaticCOB(self.Menu.CurrentMenu) != 3)
            level toStaticCOB(self.Menu.CurrentMenu, undefined, 3);
        treasure = getEnt("treasure", "targetname");
        if(isdefined(treasure))
            treasure delete();
        /*for(i=0;i<level.allEnts.size;i++)
	    {
		    entity = level.allEnts[i];
		    if( ( isdefined( entity.zombie_cheat ) ) && ( entity.zombie_cheat < 1 ) && ( isdefined( entity.classname ) ) && ( entity.classname == "info_volume" ) && ( isdefined( entity.targetname ) ) && ( entity.targetname == "treasure" ) )
            {
                entity delete();
                break;
            }
	    }*/
        self destroyHud();
    }
}

_destroyMenuText()
{
    if(isDefined(self.Hud.Text))
    {
        if(self.Hud.Text.size > 0)
        {
            for(i=0;i<self.Hud.Text.size;i++)
            {
                self.Hud.Text[i] destroy();
            }
        }
    }
}

destroyHud()
{
    if(self.Menu.Opened)
    {
        self.Menu.Opened = false;
        self _destroyMenuText();
        if(isDefined(self.Hud.Input))
        {
            self.Hud.Input destroy();
            self.Hud.Input = undefined;
        }
        if(isDefined(self.Hud.Background))
        {
            self.Hud.Background destroy();
            self.Hud.Background = undefined;
        }
        if(isDefined(self.Hud.First))
        {
            self.Hud.First destroy();
            self.Hud.First = undefined;
        }
        if(isDefined(self.Hud.Second))
        {
            self.Hud.Second destroy();
            self.Hud.Second = undefined;
        }
        if(isDefined(self.Hud.Third))
        {
            self.Hud.Third destroy();
            self.Hud.Third = undefined;
        }
        if(isDefined(self.Hud.Controls))
        {
            self.Hud.Controls destroy();
            self.Hud.Controls = undefined;
        }
        if(isDefined(self.Hud.Letter))
        {
            self.Hud.Letter destroy();
            self.Hud.Letter = undefined;
        }
        if(isDefined(self.Hud.Title))
        {
            self.Hud.Title destroy();
            self.Hud.Title = undefined;
        }
        if(isDefined(self.Hud.Size))
        {
            self.Hud.Size destroy();
            self.Hud.Size = undefined;
        }
        if(isDefined(self.Hud.Scrollbar))
        {
            self.Hud.Scrollbar destroy();
            self.Hud.Scrollbar = undefined;
        }
    }
}

_destroyMenu()
{
    flag_wait("electricity_on");
    self destroyHud();
}

createText(text, y, relative, fontscale, color)
{
    if(isString(text))
    {
        if(!isNumber(fontscale))
            fontscale = 1;
        textElem = CreateFontString("default", fontscale, self);
        if(!isString(relative))
            relative = "CENTER";
        if(!isNumber(y))
            y = 0;
        textElem setPoint("CENTER", relative, 0, y);
        textElem.foreground = true;
        textElem.sort = 0;
        textElem.type = "text";
        textElem setText(text);
        if(!isNumber(color))
            color = (1, 1, 1);
        textElem.color = color;
        textElem.alpha = 1;
        textElem.glowColor = (0,0,0);
        textElem.glowAlpha = 0;
        textElem.hidden = false;
        textElem.hideWhenInMenu = true;
        return textElem;
    }
}

createRectangle(height, y, alpha, color)
{
    if(isNumber(height))
    {
        barElemBG = newClientHudElem(self);
        barElemBG.elemType = "bar";
        barElemBG.hideWhenInMenu = true;
        if (!level.splitScreen)
        {
            barElemBG.x = -2;
            barElemBG.y = -2;
        }
        barElemBG.width = 700;
        barElemBG.height = height;
        barElemBG.align = "CENTER";
        barElemBG.relative = "CENTER";
        barElemBG.xOffset = 0;
        barElemBG.yOffset = 0;
        barElemBG.children = [];
        if(!isNumber(color))
            color = (0, 0, 0);
        barElemBG.color = color;
        if(!isNumber(alpha))
            alpha = 1;
        barElemBG.alpha = alpha;
        barElemBG setShader("white", barElemBG.width, barElemBG.height);
        barElemBG.hidden = false;
        barElemBG.sort = 0;
        if(!isNumber(y))
            y = 0;
        barElemBG setPoint(barElemBG.align, barElemBG.relative, 0, y);
        return barElemBG;
    }
}