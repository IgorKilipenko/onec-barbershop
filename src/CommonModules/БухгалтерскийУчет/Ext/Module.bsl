﻿#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
//  - ПланВидовХарактеристик.ВидыСубконто
Функция ПолучитьВидСубконтоПоСчету(Знач счет) Экспорт
    видыСубконто = счет.ВидыСубконто;

    Если видыСубконто.Количество() = 0 Тогда
        Возврат Неопределено;
    КонецЕсли;

    Возврат видыСубконто[0].ВидСубконто;
КонецФункции

// Возвращаемое значение:
//  - Булево
Функция ЗаполнитьСубконтоПоСчету(Знач счет, субконто, Знач значение) Экспорт
    видСубконто = ПолучитьВидСубконтоПоСчету(счет);
    Если видСубконто = Неопределено Тогда
        Возврат Ложь;
    КонецЕсли;

    субконто[видСубконто] = значение;
    Возврат Истина;
КонецФункции

// Параметры:
//  описаниеДебетаСчета - Структура, Неопределено - Структура вида: { Счет, Субконто }
//  описаниеКредитаСчета - Структура, Неопределено - Структура вида: { Счет, Субконто }
//  содержаниеОперации - Строка, Неопределено
// Возвращаемое значение:
//  - Структура - Структура вида: { Дебет: {Счет, Субконто}, Кредит: {Счет, Субконто}, СодержаниеОперации }
Функция СоздатьСтруктуруАналитикиПроводки(
        Знач описаниеДебетаСчета = Неопределено,
        Знач описаниеКредитаСчета = Неопределено,
        Знач содержаниеОперации = Неопределено) Экспорт

    // Проверка аргументов
    контекстДиагностики = получитьКонтекстДиагностики("СоздатьСтруктуруАналитикиПроводки");
    ДиагностикаКлиентСервер.Утверждение(описаниеДебетаСчета = Неопределено
            ИЛИ этоДопустимоеОписаниеСчета(описаниеДебетаСчета),
            "Аргумент ""ОписаниеДебетаСчета"" имеет недопустимое значение.", контекстДиагностики);
    ДиагностикаКлиентСервер.Утверждение(описаниеКредитаСчета = Неопределено
            ИЛИ этоДопустимоеОписаниеСчета(описаниеКредитаСчета),
            "Аргумент ""ОписаниеКредитаСчета"" имеет недопустимое значение.", контекстДиагностики);
    ДиагностикаКлиентСервер.Утверждение(содержаниеОперации = Неопределено
            ИЛИ ТипЗнч(содержаниеОперации) = Тип("Строка"),
            "Аргумент ""СодержаниеОперации"" имеет недопустимое значение.", контекстДиагностики);

    описаниеДебетаСчета = ?(описаниеДебетаСчета = Неопределено, СоздатьОписаниеСчета(), описаниеДебетаСчета);
    описаниеКредитаСчета = ?(описаниеКредитаСчета = Неопределено, СоздатьОписаниеСчета(), описаниеКредитаСчета);

    структураАналитики = Новый Структура;
    структураАналитики.Вставить("Дебет", описаниеДебетаСчета);
    структураАналитики.Вставить("Кредит", описаниеКредитаСчета);
    структураАналитики.Вставить("СодержаниеОперации", содержаниеОперации);

    Возврат структураАналитики;
КонецФункции

// Возвращаемое значение:
//  - Структура - Структура вида: { Счет, Субконто }
Функция СоздатьОписаниеСчета(Знач счет = Неопределено, Знач субконто = Неопределено) Экспорт
    Возврат Новый Структура("Счет, Субконто", счет, субконто);
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  описаниеСчета - Структура - Структура вида: { Счет, Субконто }
// Возвращаемое значение:
//  - Булево
Функция этоДопустимоеОписаниеСчета(Знач описаниеСчета)
    типОписания = ТипЗнч(описаниеСчета);
    результат = описаниеСчета <> Неопределено И типОписания = Тип("Структура");
    Если НЕ результат Тогда
        Возврат Ложь;
    КонецЕсли;

    обязательныеПоля = Новый Массив;
    обязательныеПоля.Добавить("Счет");
    обязательныеПоля.Добавить("Субконто");

    Для Каждого имяПоля Из обязательныеПоля Цикл
        результат = результат И описаниеСчета.Свойство(имяПоля);
        Если НЕ результат Тогда
            Прервать;
        КонецЕсли;
    КонецЦикла;

    Возврат результат;
КонецФункции

// Возвращаемое значение:
//  - Строка
Функция получитьКонтекстДиагностики(Знач имяФункции = Неопределено)
    базовыйКонтекстДиагностики = "БухгалтерскийУчет";
    Возврат ?(ЗначениеЗаполнено(имяФункции), СтрШаблон("%1.%2", базовыйКонтекстДиагностики, имяФункции), базовыйКонтекстДиагностики);
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
