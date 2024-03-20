﻿#Область ПрограммныйИнтерфейс

// Параметры:
//  сотрудникСсылка - СправочникСсылка.Сотрудники
//  моментВремени - Дата, МоментВремени, Граница, Неопределено
// Возвращаемое значение:
//  - Число, Неопределено
Функция ПолучитьОкладСотрудника(Знач сотрудникСсылка, Знач моментВремени = Неопределено) Экспорт
    кадровыеДанныеСотрудника = ПолучитьКадровыеДанныеСотрудника(сотрудникСсылка, моментВремени);
    Если кадровыеДанныеСотрудника = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    Возврат кадровыеДанныеСотрудника.Оклад;
КонецФункции

// Параметры:
//  сотрудникСсылка - СправочникСсылка.Сотрудники
//  моментВремени - Дата, МоментВремени, Граница, Неопределено
// Возвращаемое значение:
//  - Структура, Неопределено
Функция ПолучитьКадровыеДанныеСотрудника(Знач сотрудникСсылка, Знач моментВремени = Неопределено) Экспорт
    поляДанных = "Период, ГрафикРаботы, Оклад, Работает";
    структураПолей = Новый Структура(поляДанных);
    выборка = ПолучитьКадровыеДанные(структураПолей,
            Новый Структура("Сотрудник, МоментВремени", сотрудникСсылка, моментВремени), Ложь);

    Если выборка = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    выборка.Следующий();
    ЗаполнитьЗначенияСвойств(структураПолей, выборка, поляДанных);

    Возврат структураПолей;
КонецФункции

// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура
//  параметры - Структура, ФиксированнаяСтруктура
//      * МоментВремени - Дата, МоментВремени, Граница, Неопределено
//      * Сотрудник - СправочникСсылка.Сотрудники, Неопределено
//      * ГрафикРаботы - СправочникСсылка.ГрафикиРаботыСотрудников, Неопределено
//      * ВыбратьРазрешенные - Булево
//  выгрузить - Булево - Если Истина - результат будет возвращен в виде ТаблицаЗначений, по умолчанию: Истина
// Возвращаемое значение:
//  - ТаблицаЗначений, ВыборкаИзРезультатаЗапроса, Неопределено
Функция ПолучитьКадровыеДанные(Знач структураПолей, Знач параметры, выгрузить = Неопределено) Экспорт
    Возврат получитьДанныеРегистра("СрезПоследних", структураПолей, параметры, выгрузить);
КонецФункции

// Получает данные среза последних (на дату начала периода) и записей кадровой истории
// за указанный период времени из регистра КадроваяИсторияСотрудников по всем сотрудникам
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура
//  параметры - Структура, ФиксированнаяСтруктура
//      * МоментВремени - Дата, МоментВремени, Граница, Неопределено
//      * Сотрудник - СправочникСсылка.Сотрудники, Неопределено
//      * ГрафикРаботы - СправочникСсылка.ГрафикиРаботыСотрудников, Неопределено
//      * ВыбратьРазрешенные - Булево
//  выгрузить - Булево - Если Истина - результат будет возвращен в виде ТаблицаЗначений, по умолчанию: Истина
// Возвращаемое значение:
//  - ТаблицаЗначений, ВыборкаИзРезультатаЗапроса, Неопределено
Функция ПолучитьКадровыеДанныеИнтервал(Знач структураПолей, Знач параметры, выгрузить = Неопределено) Экспорт
    Возврат получитьДанныеРегистра("СрезПоследнихИнтервал", Неопределено, параметры, выгрузить);
КонецФункции

// Устарела.Не используется в текущей реализации
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//      * НачалоПериода - Дата, МоментВремени, Граница
//      * КонецПериода - Дата, МоментВремени, Граница
//      * ВыбратьРазрешенные - Булево
//  выгрузить - Булево - Если Истина - результат будет возвращен в виде ТаблицаЗначений, по умолчанию: Истина
// Возвращаемое значение:
//  - ТаблицаЗначений, ВыборкаИзРезультатаЗапроса, Неопределено
Функция ПолучитьИсториюЗаПериод(Знач структураПолей, Знач параметры, выгрузить = Неопределено) Экспорт
    Возврат получитьДанныеРегистра("История", структураПолей, параметры, выгрузить);
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
    Если видЗапроса = "История" Тогда
        запрос = сформироватьЗапросИсторииЗаПериод(структураПолей, параметры);
    ИначеЕсли видЗапроса = "СрезПоследних" Тогда
        запрос = сформироватьЗапросСрезПоследних(структураПолей, параметры);
    ИначеЕсли видЗапроса = "СрезПоследнихИнтервал" Тогда
        запрос = сформироватьЗапросСрезПоследнихИсторияЗаПериод(параметры);
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
// Формирует запрос записей среза последних за указанный период времени из регистра КадроваяИсторияСотрудников
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура
//      * Период - Строка, Неопределено
//      * Сотрудник - Строка, Неопределено
//      * ГрафикРаботы - Строка, Неопределено
//      * Оклад - Строка, Неопределено
//      * Работает - Строка, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//      * МоментВремени - Дата, МоментВремени, Граница, Неопределено
//      * Сотрудник - СправочникСсылка.Сотрудники, Неопределено
//      * ГрафикРаботы - СправочникСсылка.ГрафикиРаботыСотрудников, Неопределено
//      * ВыбратьРазрешенные - Булево
// Возвращаемое значение:
//  - Запрос
Функция сформироватьЗапросСрезПоследних(Знач структураПолей, Знач параметры)
    параметры = ?(параметры = Неопределено, Новый Структура("МоментВремени, ВыбратьРазрешенные", Неопределено, Ложь), параметры);

    #Область Диагностика
    выполнитьДиагностикуСтруктурыПолей(структураПолей);
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(параметры) = Тип("Структура") ИЛИ ТипЗнч(параметры) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""Параметры"" должен иметь тип ""[Фиксированная]Структура"".");
    #КонецОбласти // Диагностика

    обязательныеПоля = Новый ФиксированнаяСтруктура("Период, Сотрудник", "Период", "Сотрудник");
    структураПолей = Новый Структура(структураПолей);

    Если НЕ структураПолей.Свойство(обязательныеПоля.Период) Тогда
        структураПолей.Вставить(обязательныеПоля.Период, обязательныеПоля.Период);
    КонецЕсли;

    Если НЕ структураПолей.Свойство(обязательныеПоля.Сотрудник) Тогда
        структураПолей.Вставить(обязательныеПоля.Сотрудник, обязательныеПоля.Сотрудник);
    КонецЕсли;

    отборВыбратьРазрешенные = ?(параметры.Свойство("ВыбратьРазрешенные"), параметры.ВыбратьРазрешенные, Ложь);
    отборМоментВремени = ?(параметры.Свойство("МоментВремени"), параметры.МоментВремени, Неопределено);
    отборСотрудник = ?(параметры.Свойство("Сотрудник"), параметры.Сотрудник, Неопределено);
    отборГрафик = ?(параметры.Свойство("ГрафикРаботы"), параметры.ГрафикРаботы, Неопределено);

    текстУсловий = Неопределено;

    текстЗапросаПолей = РаботаСРеквизитами.СформироватьТекстЗапросаПолейПоРеквизитам(
            структураПолей, "КадроваяИсторияСотрудниковСрезПоследних");
    текстЗапросаПолей = ?(ПустаяСтрока(текстЗапросаПолей), "*", текстЗапросаПолей);

    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   &ТекстЗапросаПолей
        |ПОМЕСТИТЬ ВТ_КадроваяИстория
        |ИЗ
        |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ПараметрыВТ) КАК КадроваяИсторияСотрудниковСрезПоследних
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	&ТекстЗапросаПолей
        |ИЗ
        |	ВТ_КадроваяИстория КАК КадроваяИсторияСотрудниковСрезПоследних
        |ГДЕ
        |	(КадроваяИсторияСотрудниковСрезПоследних.Период, КадроваяИсторияСотрудниковСрезПоследних.Сотрудник) В
        |			(ВЫБРАТЬ
        |				МАКСИМУМ(Т.Период) КАК Период,
        |               Т.Сотрудник КАК Сотрудник
        |			ИЗ
        |				ВТ_КадроваяИстория КАК Т
        |			СГРУППИРОВАТЬ ПО
        |				Т.Сотрудник)
        |";

    параметрыВТ = "&МоментВремени, &Условие";

    Если отборМоментВремени = Неопределено Тогда
        параметрыВТ = СтрЗаменить(параметрыВТ, "&МоментВремени", "");
    Иначе
        запрос.УстановитьПараметр("МоментВремени", отборМоментВремени);
    КонецЕсли;

    Если отборСотрудник <> Неопределено Тогда
        текстУсловий = СтрШаблон("Сотрудник %1 &Сотрудник", ?(РаботаСКоллекциямиКлиентСервер.ЭтоМассив(отборСотрудник, Ложь), "В", "="));
        запрос.УстановитьПараметр("Сотрудник", отборСотрудник);
    КонецЕсли;

    Если отборГрафик <> Неопределено Тогда
        текстУсловий = СтрШаблон("%1 %2%3", текстУсловий, ?(текстУсловий <> Неопределено, "И ", ""), "ГрафикРаботы = &ГрафикРаботы");
        запрос.УстановитьПараметр("ГрафикРаботы", отборГрафик);
    КонецЕсли;

    Если НЕ отборВыбратьРазрешенные Тогда
        запрос.Текст = СтрЗаменить(запрос.Текст, "РАЗРЕШЕННЫЕ", "");
    КонецЕсли;

    параметрыВТ = СтрЗаменить(параметрыВТ, "&Условие", ?(текстУсловий = Неопределено, "", текстУсловий));

    запрос.Текст = СтрЗаменить(запрос.Текст, "&ПараметрыВТ", параметрыВТ);
    запрос.Текст = СтрЗаменить(запрос.Текст, "&ТекстЗапросаПолей", текстЗапросаПолей);

    Возврат запрос;
КонецФункции

// Формирует запрос записей за указанный период времени из регистра КадроваяИсторияСотрудников
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//      * НачалоПериода - Дата, МоментВремени, Граница
//      * КонецПериода - Дата, МоментВремени, Граница
//      * Сотрудник - СправочникСсылка.Сотрудники, Неопределено
//      * ГрафикРаботы - СправочникСсылка.ГрафикиРаботыСотрудников, Неопределено
//      * Работает - Булево, Неопределено
//      * ВыбратьРазрешенные - Булево
// Возвращаемое значение:
//  - Запрос
Функция сформироватьЗапросИсторииЗаПериод(Знач структураПолей, Знач параметры)
    #Область ДиагностикаАргументов
    Если структураПолей <> Неопределено Тогда
        выполнитьДиагностикуСтруктурыПолей(структураПолей);
    КонецЕсли;
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(параметры) = Тип("Структура") ИЛИ ТипЗнч(параметры) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""Параметры"" должен иметь тип ""[Фиксированная]Структура"".");
    ДиагностикаКлиентСервер.Утверждение(
        параметры.Свойство("НачалоПериода") И параметры.Свойство("КонецПериода"),
        "Аргумент ""Параметры"" должен иметь ключи: ""НачалоПериода, ""КонецПериода"".");
    #КонецОбласти // ДиагностикаАргументов

    Если структураПолей <> Неопределено Тогда
        структураПолей = Новый Структура(структураПолей);
    КонецЕсли;

    началоПериода = параметры.НачалоПериода;
    конецПериода = параметры.КонецПериода;

    отборВыбратьРазрешенные = ?(параметры.Свойство("ВыбратьРазрешенные"), параметры.ВыбратьРазрешенные, Ложь);
    отборСотрудник = ?(параметры.Свойство("Сотрудник"), параметры.Сотрудник, Неопределено);
    отборГрафик = ?(параметры.Свойство("ГрафикРаботы"), параметры.ГрафикРаботы, Неопределено);
    отборРаботает = ?(параметры.Свойство("Работает"), параметры.Работает, Неопределено);
    текстУсловий = Неопределено;

    текстЗапросаПолей = Неопределено;

    Если структураПолей = Неопределено Тогда
        текстЗапросаПолей = получитьТекстЗапросаВсехПолей();
    Иначе
        текстЗапросаПолей = РаботаСРеквизитами.СформироватьТекстЗапросаПолейПоРеквизитам(
                структураПолей, "КадроваяИсторияСотрудников");
    КонецЕсли;

    ДиагностикаКлиентСервер.Утверждение(текстЗапросаПолей <> Неопределено И НЕ ПустаяСтрока(текстЗапросаПолей),
        "Текст запроса полей должен быть заполнен.");

    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   &ТекстЗапросаПолей
        |ИЗ
        |	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
        |ГДЕ
        |   КадроваяИсторияСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода
        |   И &Условие
        |
        |УПОРЯДОЧИТЬ ПО
        |   КадроваяИсторияСотрудников.Сотрудник.Наименование,
        |   КадроваяИсторияСотрудников.Период
        |";

    Если НЕ отборВыбратьРазрешенные Тогда
        запрос.Текст = СтрЗаменить(запрос.Текст, "РАЗРЕШЕННЫЕ", "");
    КонецЕсли;

    Если структураПолей <> Неопределено И структураПолей.Свойство("Сотрудник") Тогда
        запрос.Текст = СтрЗаменить(запрос.Текст, "КадроваяИсторияСотрудников.Сотрудник.Наименование,", "");
    КонецЕсли;

    запрос.УстановитьПараметр("НачалоПериода", началоПериода);
    запрос.УстановитьПараметр("КонецПериода", конецПериода);

    опциональныеПараметры = Новый Массив;
    ключиПараметра = "Имя, ЭтоМассив";
    Если отборСотрудник <> Неопределено Тогда
        опциональныеПараметры.Добавить(Новый Структура(ключиПараметра, "Сотрудник",
                РаботаСКоллекциямиКлиентСервер.ЭтоМассив(отборСотрудник, Ложь)));
        запрос.УстановитьПараметр("Сотрудник", отборСотрудник);
    КонецЕсли;
    Если отборГрафик <> Неопределено Тогда
        опциональныеПараметры.Добавить(Новый Структура(ключиПараметра, "ГрафикРаботы",
                РаботаСКоллекциямиКлиентСервер.ЭтоМассив(отборГрафик, Ложь)));
        запрос.УстановитьПараметр("ГрафикРаботы", отборГрафик);
    КонецЕсли;
    Если отборРаботает <> Неопределено Тогда
        опциональныеПараметры.Добавить(Новый Структура(ключиПараметра, "Работает", Ложь));
        запрос.УстановитьПараметр("Работает", отборРаботает);
    КонецЕсли;

    текстУсловий = получитьТекстУсловияПоОпциональнымПараметрам(опциональныеПараметры, текстУсловий);

    запрос.Текст = СтрЗаменить(запрос.Текст, "И &Условие", ?(текстУсловий = Неопределено, "", текстУсловий));
    запрос.Текст = СтрЗаменить(запрос.Текст, "&ТекстЗапросаПолей", текстЗапросаПолей);

    Возврат запрос;
КонецФункции

// Формирует запрос записей среза последних (на дату начала периода) и новых записей
// за указанный период времени из регистра КадроваяИсторияСотрудников
//
// Параметры:
//  структураПолей - Структура, ФиксированнаяСтруктура, Неопределено
//  параметры - Структура, ФиксированнаяСтруктура
//      * НачалоПериода - Дата, МоментВремени, Граница
//      * КонецПериода - Дата, МоментВремени, Граница
//      * ВыбратьРазрешенные - Булево
// Возвращаемое значение:
//  - Запрос
Функция сформироватьЗапросСрезПоследнихИсторияЗаПериод(Знач параметры)
    #Область ДиагностикаАргументов
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(параметры) = Тип("Структура") ИЛИ ТипЗнч(параметры) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""Параметры"" должен иметь тип ""[Фиксированная]Структура"".");
    ДиагностикаКлиентСервер.Утверждение(
        параметры.Свойство("НачалоПериода") И параметры.Свойство("КонецПериода"),
        "Аргумент ""Параметры"" должен иметь ключи: ""НачалоПериода, ""КонецПериода"".");
    #КонецОбласти // ДиагностикаАргументов

    отборНачалоПериода = параметры.НачалоПериода;
    отборКонецПериода = параметры.КонецПериода;
    отборВыбратьРазрешенные = ?(параметры.Свойство("ВыбратьРазрешенные"), параметры.ВыбратьРазрешенные, Ложь);

    текстЗапросаПолей = получитьТекстЗапросаВсехПолей();

    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |	ГрафикиРаботыСотрудников.Ссылка КАК Ссылка
        |ПОМЕСТИТЬ ВТ_ГрафикиРаботы
        |ИЗ
        |	Справочник.ГрафикиРаботыСотрудников КАК ГрафикиРаботыСотрудников
        |ГДЕ
        |	ГрафикиРаботыСотрудников.ПометкаУдаления = ЛОЖЬ
        |	И ГрафикиРаботыСотрудников.КонецПериода >= &НачалоПериода
        |	И ГрафикиРаботыСотрудников.НачалоПериода <= &КонецПериода
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |	&ТекстЗапросаПолей
        |ПОМЕСТИТЬ ВТ_КадроваяИсторияСрезПоследних
        |ИЗ
        |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(
        |			&НачалоПериода,
        |			ГрафикРаботы В
        |				(ВЫБРАТЬ
        |					ВТ_ГрафикиРаботы.Ссылка КАК Ссылка
        |				ИЗ
        |					ВТ_ГрафикиРаботы КАК ВТ_ГрафикиРаботы)) КАК КадроваяИсторияСотрудников
        |ГДЕ
        |	КадроваяИсторияСотрудников.Работает
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |	&ТекстЗапросаПолей
        |ПОМЕСТИТЬ ВТ_КадроваяИстория
        |ИЗ
        |	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
        |ГДЕ
        |	КадроваяИсторияСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода
        |	И НЕ КадроваяИсторияСотрудников.Период В
        |				(ВЫБРАТЬ
        |					ВТ_КадроваяИсторияСрезПоследних.Период КАК Период
        |				ИЗ
        |					ВТ_КадроваяИсторияСрезПоследних КАК ВТ_КадроваяИсторияСрезПоследних)
        |
        |ОБЪЕДИНИТЬ ВСЕ
        |
        |ВЫБРАТЬ
        |	&ТекстЗапросаПолей
        |ИЗ
        |	ВТ_КадроваяИсторияСрезПоследних КАК КадроваяИсторияСотрудников
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	&ТекстЗапросаПолей
        |ИЗ
        |	ВТ_КадроваяИстория КАК КадроваяИсторияСотрудников
        |
        |УПОРЯДОЧИТЬ ПО
        |	КадроваяИсторияСотрудников.Сотрудник.Наименование,
        |	Период
        |";

    Если НЕ отборВыбратьРазрешенные Тогда
        запрос.Текст = СтрЗаменить(запрос.Текст, "РАЗРЕШЕННЫЕ", "");
    КонецЕсли;

    запрос.УстановитьПараметр("НачалоПериода", отборНачалоПериода);
    запрос.УстановитьПараметр("КонецПериода", отборКонецПериода);

    запрос.Текст = СтрЗаменить(запрос.Текст, "&ТекстЗапросаПолей", текстЗапросаПолей);

    Возврат запрос;
КонецФункции

Процедура выполнитьДиагностикуСтруктурыПолей(Знач структураПолей)
    ДиагностикаКлиентСервер.Утверждение(
        ТипЗнч(структураПолей) = Тип("Структура") ИЛИ ТипЗнч(структураПолей) = Тип("ФиксированнаяСтруктура"),
            "Аргумент ""СтруктураПолей"" должен иметь тип ""[Фиксированная]Структура"".");
КонецПроцедуры

Функция получитьТекстУсловияПоОпциональнымПараметрам(Знач параметры, Знач строкаУсловий)
    Для Каждого элемент Из параметры Цикл
        Возврат СтрШаблон("%1 %2%3", строкаУсловий, ?(строкаУсловий <> Неопределено, "И ", ""),
            СтрШаблон("%1 %2 &%1", элемент.Имя, ?(элемент.ЭтоМассив, "В", "=")));
    КонецЦикла;
КонецФункции

Функция получитьТекстЗапросаВсехПолей()
    текстЗапросаПолей =
        "   КадроваяИсторияСотрудников.Период КАК Период,
        |	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник,
        |	КадроваяИсторияСотрудников.ГрафикРаботы КАК ГрафикРаботы,
        |	КадроваяИсторияСотрудников.Оклад КАК Оклад,
        |	КадроваяИсторияСотрудников.Работает КАК Работает
        |";

    Возврат текстЗапросаПолей;
КонецФункции
#КонецОбласти // ЗапросыДанных

#КонецОбласти // СлужебныеПроцедурыИФункции
