﻿#Область ПрограммныйИнтерфейс

// Возвращает цену номенклатуры поставщика (срез последних)
// Параметры:
//  номенклатураСсылка - СправочникСсылка.Номенклатура
//  поставщикСсылка - СправочникСсылка.Контрагенты
//  моментВремени - Дата, МоментВремени, Граница, Неопределено
// Возвращаемое значение:
//  - Число, Неопределено
Функция ПолучитьЦенуНоменклатуры(Знач номенклатураСсылка, Знач поставщикСсылка, Знач моментВремени = Неопределено) Экспорт
    параметрыОтбора = Новый Структура("МоментВремени, Номенклатура, Поставщик", моментВремени, номенклатураСсылка, поставщикСсылка);
    результат = получитьДанныеРегистра("СрезПоследних",
            Новый ФиксированнаяСтруктура("Цена"), параметрыОтбора, Истина);
    Возврат ?(результат = Неопределено ИЛИ результат.Количество() = 0, Неопределено, результат[0].Цена);
КонецФункции

// Возвращает срез последних цен номенклатуры поставщика из указанного списка номенклатуры
// Параметры:
//  списокНоменклатуры - Массив Из СправочникСсылка.Номенклатура
//  поставщикСсылка - СправочникСсылка.Контрагенты
//  моментВремени - Дата, МоментВремени, Граница, Неопределено
//  получатьПредставлениеНоменклатуры - Булево
// Возвращаемое значение:
//  - ТаблицаЗначений - Колонки таблицы: [Период, Номенклатура, Цена]
//  - Неопределено - Если данные с указанными параметрами отсутствуют в регистре
Функция ПолучитьСписокЦенНоменклатуры(
        Знач списокНоменклатуры,
        Знач поставщикСсылка,
        Знач моментВремени = Неопределено,
        Знач получатьПредставлениеНоменклатуры = Ложь) Экспорт

    параметрыОтбора = Новый Структура("МоментВремени, Номенклатура, Поставщик", моментВремени, списокНоменклатуры, поставщикСсылка);
    структураПолей = Новый ФиксированнаяСтруктура(СтрШаблон("Номенклатура, Цена%1",
                ?(получатьПредставлениеНоменклатуры, ", НоменклатураПредставление", "")));

    Возврат получитьДанныеРегистра("СрезПоследних", структураПолей, параметрыОтбора, Истина);
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  видЗапроса - Строка
//  структураПолей - Структура, ФиксированнаяСтруктура, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//  выгрузить - Булево - Если Истина - результат будет возвращен в виде ТаблицаЗначений, по умолчанию: Истина
// Возвращаемое значение:
//  - ТаблицаЗначений, ВыборкаИзРезультатаЗапроса, Неопределено
Функция получитьДанныеРегистра(Знач видЗапроса, Знач структураПолей, Знач параметры, выгрузить = Неопределено)
    выгрузить = ?(выгрузить = Неопределено, Истина, выгрузить);

    запрос = Неопределено;
    Если видЗапроса = "СрезПоследних" Тогда
        запрос = сформироватьЗапросСрезПоследних(структураПолей, параметры);
    Иначе
        ДиагностикаКлиентСервер.Утверждение(Ложь,
            СтрШаблон("Указанный вид запроса: ""%1"" не поддерживается.", Строка(видЗапроса)));
    КонецЕсли;
    ДиагностикаКлиентСервер.Утверждение(запрос <> Неопределено,
        "Ошибка при формировании запроса на получение данных регистра.");

    результатЗапроса = запрос.Выполнить();

    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    Если выгрузить Тогда
        Возврат результатЗапроса.Выгрузить();
    Иначе
        Возврат результатЗапроса.Выбрать();
    КонецЕсли;
КонецФункции

#Область ЗапросыДанных
// Формирует запрос записей среза последних за указанный период времени из регистра ЦеныНоменклатурыПоставщиков
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура
//      * Период - Строка, Неопределено
//      * Регистратор - Строка, Неопределено
//      * Активность - Строка, Неопределено
//      * Сотрудник - Строка, Неопределено
//      * Поставщик - Строка, Неопределено
//      * Цена - Строка, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//      * МоментВремени - Дата, МоментВремени, Граница, Неопределено
//      * Номенклатура - СправочникСсылка.Номенклатура, ФиксированныйМассив, Неопределено
//      * Поставщик - СправочникСсылка.Контрагенты, Неопределено
//      * ВыбратьРазрешенные - Булево
// Возвращаемое значение:
//  - Запрос
Функция сформироватьЗапросСрезПоследних(Знач структураПолей, Знач параметры)
    псевдонимТаблицы = "ЦеныНоменклатурыПоставщиковСрезПоследних";

    параметры = ?(параметры = Неопределено, Новый Структура("МоментВремени, ВыбратьРазрешенные", Неопределено, Ложь), параметры);

    #Область ДиагностикаАргументов
    выполнитьДиагностикуСтруктурыПолей(структураПолей);
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(параметры) = Тип("Структура") ИЛИ ТипЗнч(параметры) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""Параметры"" должен иметь тип ""[Фиксированная]Структура"".");
    #КонецОбласти // ДиагностикаАргументов

    структураПолей = Новый Структура(структураПолей);
    обязательныеПоля = Новый ФиксированнаяСтруктура("Период", "Период");

    полеПредставленияНоменклатуры = Неопределено;
    Если структураПолей.Свойство("НоменклатураПредставление", полеПредставленияНоменклатуры) Тогда
        полеПредставленияНоменклатуры = ?(полеПредставленияНоменклатуры = Неопределено,
                "НоменклатураПредставление", полеПредставленияНоменклатуры);
    КонецЕсли;

    // Устарела. Период нужно исключить из обязательных полей!
    Если НЕ структураПолей.Свойство(обязательныеПоля.Период) Тогда
        структураПолей.Вставить(обязательныеПоля.Период, обязательныеПоля.Период);
    КонецЕсли;

    // Инициализация параметров отбора
    отборВыбратьРазрешенные = ?(параметры.Свойство("ВыбратьРазрешенные"), параметры.ВыбратьРазрешенные, Ложь);
    отборМоментВремени = ?(параметры.Свойство("МоментВремени"), параметры.МоментВремени, Неопределено);
    отборНоменклатура = ?(параметры.Свойство("Номенклатура"), параметры.Номенклатура, Неопределено);
    отборПоставщик = ?(параметры.Свойство("Поставщик"), параметры.Поставщик, Неопределено);

    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   &ТекстЗапросаПолей
        |ИЗ
        |	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(&ПараметрыВТ) КАК &ПсевдонимТаблицы
        |";

    // Формирование параметров запроса ВТ
    параметрыВТ = "&МоментВремени, &Условие";

    Если отборМоментВремени = Неопределено Тогда
        параметрыВТ = СтрЗаменить(параметрыВТ, "&МоментВремени", "");
    Иначе
        запрос.УстановитьПараметр("МоментВремени", отборМоментВремени);
    КонецЕсли;

    // Формирование условий запроса ВТ
    строкаУсловий = Неопределено;
    опциональныеПараметры = Новый Массив;
    ключиПараметра = "Имя, ЭтоМассив";
    Если отборНоменклатура <> Неопределено Тогда
        опциональныеПараметры.Добавить(Новый Структура(ключиПараметра, "Номенклатура",
                РаботаСКоллекциямиКлиентСервер.ЭтоМассив(отборНоменклатура, Ложь)));
        запрос.УстановитьПараметр("Номенклатура", отборНоменклатура);
    КонецЕсли;
    Если отборПоставщик <> Неопределено Тогда
        опциональныеПараметры.Добавить(Новый Структура(ключиПараметра, "Поставщик",
                РаботаСКоллекциямиКлиентСервер.ЭтоМассив(отборПоставщик, Ложь)));
        запрос.УстановитьПараметр("Поставщик", отборПоставщик);
    КонецЕсли;
    строкаУсловий = получитьТекстУсловияПоОпциональнымПараметрам(опциональныеПараметры, строкаУсловий);

    // Формирование текста запроса
    текстЗапросаПолей = РаботаСРеквизитами.СформироватьТекстЗапросаПолейПоРеквизитам(структураПолей, псевдонимТаблицы);
    // Устарела. Данную функциональность (работу с разыменованием) необходимо выполнять в
    //  РаботаСРеквизитами.СформироватьТекстЗапросаПолейПоРеквизитам
    Если полеПредставленияНоменклатуры <> Неопределено Тогда
        текстЗапросаПолей = РаботаСоСтрокамиВызовСервера.ЗаменитьПоРегулярномуВыражению(
                текстЗапросаПолей, "(?<=\.)НоменклатураПредставление(?=\s+КАК\s)",
                "Номенклатура.Представление");
    Иначе
        текстЗапросаПолей = ?(ПустаяСтрока(текстЗапросаПолей), "*", текстЗапросаПолей);
    КонецЕсли;

    Если НЕ отборВыбратьРазрешенные Тогда
        запрос.Текст = СтрЗаменить(запрос.Текст, "РАЗРЕШЕННЫЕ", "");
    КонецЕсли;

    параметрыВТ = СтрЗаменить(параметрыВТ, "&Условие", ?(строкаУсловий = Неопределено, "", строкаУсловий));

    запрос.Текст = СтрЗаменить(запрос.Текст, "&ПсевдонимТаблицы", псевдонимТаблицы);
    запрос.Текст = СтрЗаменить(запрос.Текст, "&ПараметрыВТ", параметрыВТ);
    запрос.Текст = СтрЗаменить(запрос.Текст, "&ТекстЗапросаПолей", текстЗапросаПолей);

    Возврат запрос;
КонецФункции
#КонецОбласти // ЗапросыДанных

Функция получитьТекстУсловияПоОпциональнымПараметрам(Знач параметры, Знач строкаУсловий)
    Для Каждого элемент Из параметры Цикл
        результат = СтрШаблон(
                "%1 %2%3", строкаУсловий,
                ?(строкаУсловий <> Неопределено, "И ", ""),
                СтрШаблон("%1 = &%1", элемент.Имя));

        Если элемент.ЭтоМассив Тогда
            результат = РаботаСоСтрокамиВызовСервера.ЗаменитьПоРегулярномуВыражению(
                    результат,
                    СтрШаблон("= &%1$", элемент.Имя),
                    СтрШаблон("В (&%1)", элемент.Имя));
        КонецЕсли;

        Возврат результат;
    КонецЦикла;
КонецФункции

Процедура выполнитьДиагностикуСтруктурыПолей(Знач структураПолей)
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(структураПолей) = Тип("Структура") ИЛИ ТипЗнч(структураПолей) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""СтруктураПолей"" должен иметь тип ""[Фиксированная]Структура"".");
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
