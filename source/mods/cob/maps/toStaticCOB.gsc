#include maps\_utility;
// MAIS C'EST TERRIBLE !!!
toStaticCOB(dynamic, after, value)
{
    if(isdefined(dynamic))
    {
        if(dynamic == "bin")
        {
            if(isdefined(after))
            {
                if(after == "question")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_question = value;
                    else
                        return self.cob_quest_bin_question;
                }
                else if(after == "question_size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_question_size = value;
                    else
                        return self.cob_quest_bin_question_size;
                }
                else if(after == "size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_size = value;
                    else
                        return self.cob_quest_bin_size;
                }
                else if(after == "scroll")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_scroll = value;
                    else
                        return self.cob_quest_bin_scroll;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_lock = value;
                    else
                        return self.cob_quest_bin_lock;
                }
                else if(after == "answers")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_answers = value;
                    else
                        return self.cob_quest_bin_answers;
                }
                else if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_answer = value;
                    else
                        return self.cob_quest_bin_answer;
                }
                else if(after == "answered")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_answered = value;
                    else
                        return self.cob_quest_bin_answered;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin_level = value;
                    else
                        return self.cob_quest_bin_level;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_bin = value;
                    else
                        return self.cob_quest_bin;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_quest_bin = value;
                else
                    return self.cob_quest_bin;
            }
        }
        else if(dynamic == "burnt")
        {
            if(isdefined(after))
            {
                if(after == "question")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_question = value;
                    else
                        return self.cob_quest_burnt_question;
                }
                else if(after == "question_size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_question_size = value;
                    else
                        return self.cob_quest_burnt_question_size;
                }
                else if(after == "size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_size = value;
                    else
                        return self.cob_quest_burnt_size;
                }
                else if(after == "scroll")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_scroll = value;
                    else
                        return self.cob_quest_burnt_scroll;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_lock = value;
                    else
                        return self.cob_quest_burnt_lock;
                }
                else if(after == "answers")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_answers = value;
                    else
                        return self.cob_quest_burnt_answers;
                }
                else if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_answer = value;
                    else
                        return self.cob_quest_burnt_answer;
                }
                else if(after == "answered")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_answered = value;
                    else
                        return self.cob_quest_burnt_answered;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt_level = value;
                    else
                        return self.cob_quest_burnt_level;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_burnt = value;
                    else
                        return self.cob_quest_burnt;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_quest_burnt = value;
                else
                    return self.cob_quest_burnt;
            }
        }
        else if(dynamic == "water")
        {
            if(isdefined(after))
            {
                if(after == "question")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_question = value;
                    else
                        return self.cob_quest_water_question;
                }
                else if(after == "question_size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_question_size = value;
                    else
                        return self.cob_quest_water_question_size;
                }
                else if(after == "size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_size = value;
                    else
                        return self.cob_quest_water_size;
                }
                else if(after == "scroll")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_scroll = value;
                    else
                        return self.cob_quest_water_scroll;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_lock = value;
                    else
                        return self.cob_quest_water_lock;
                }
                else if(after == "answers")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_answers = value;
                    else
                        return self.cob_quest_water_answers;
                }
                else if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_answer = value;
                    else
                        return self.cob_quest_water_answer;
                }
                else if(after == "answered")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_answered = value;
                    else
                        return self.cob_quest_water_answered;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water_level = value;
                    else
                        return self.cob_quest_water_level;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_water = value;
                    else
                        return self.cob_quest_water;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_quest_water = value;
                else
                    return self.cob_quest_water;
            }
        }
        else if(dynamic == "flowers")
        {
            if(isdefined(after))
            {
                if(after == "question")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_question = value;
                    else
                        return self.cob_quest_flowers_question;
                }
                else if(after == "question_size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_question_size = value;
                    else
                        return self.cob_quest_flowers_question_size;
                }
                else if(after == "size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_size = value;
                    else
                        return self.cob_quest_flowers_size;
                }
                else if(after == "scroll")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_scroll = value;
                    else
                        return self.cob_quest_flowers_scroll;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_lock = value;
                    else
                        return self.cob_quest_flowers_lock;
                }
                else if(after == "answers")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_answers = value;
                    else
                        return self.cob_quest_flowers_answers;
                }
                else if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_answer = value;
                    else
                        return self.cob_quest_flowers_answer;
                }
                else if(after == "answered")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_answered = value;
                    else
                        return self.cob_quest_flowers_answered;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers_level = value;
                    else
                        return self.cob_quest_flowers_level;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_flowers = value;
                    else
                        return self.cob_quest_flowers;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_quest_flowers = value;
                else
                    return self.cob_quest_flowers;
            }
        }
        else if(dynamic == "gascan")
        {
            if(isdefined(after))
            {
                if(after == "question")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_question = value;
                    else
                        return self.cob_quest_gascan_question;
                }
                else if(after == "question_size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_question_size = value;
                    else
                        return self.cob_quest_gascan_question_size;
                }
                else if(after == "size")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_size = value;
                    else
                        return self.cob_quest_gascan_size;
                }
                else if(after == "scroll")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_scroll = value;
                    else
                        return self.cob_quest_gascan_scroll;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_lock = value;
                    else
                        return self.cob_quest_gascan_lock;
                }
                else if(after == "answers")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_answers = value;
                    else
                        return self.cob_quest_gascan_answers;
                }
                else if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_answer = value;
                    else
                        return self.cob_quest_gascan_answer;
                }
                else if(after == "answered")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_answered = value;
                    else
                        return self.cob_quest_gascan_answered;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan_level = value;
                    else
                        return self.cob_quest_gascan_level;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_quest_gascan = value;
                    else
                        return self.cob_quest_gascan;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_quest_gascan = value;
                else
                    return self.cob_quest_gascan;
            }
        }
        else if(dynamic == "treasure")
        {
            if(isdefined(after))
            {
                if(after == "answer")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_treasure_answer = value;
                    else
                        return self.cob_treasure_answer;
                }
                else if(after == "level")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_treasure_level = value;
                    else
                        return self.cob_treasure_level;
                }
                else if(after == "lock")
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_treasure_lock = value;
                    else
                        return self.cob_treasure_lock;
                }
                else
                {
                    if(isNumber(value) || isdefined(value))
                        self.cob_treasure = value;
                    else
                        return self.cob_treasure;
                }
            }
            else
            {
                if(isNumber(value) || isdefined(value))
                    self.cob_treasure = value;
                else
                    return self.cob_treasure;
            }
        }
    }
}