﻿#Область ПрограммныйИнтерфейс

// Возвращает менеджер объекта по ссылке.
// Параметры:
//  типОбъекта - Тип
// Возвращаемое значение:
//  - Менеджер
Функция ПолучитьМенеджерОбъекта(Знач типОбъекта) Экспорт
    метаданныеОбъекта = Метаданные.НайтиПоТипу(типОбъекта);
    Если метаданныеОбъекта = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    полноеИмяМетаданных = метаданныеОбъекта.ПолноеИмя();
    ДиагностикаКлиентСервер.Утверждение(
        РаботаСоСтрокамиВызовСервера.ПодобнаПоРегулярномуВыражению(
            полноеИмяМетаданных, "[А-ЯЁ][А-ЯЁа-яё]+(?:Объект|Ссылка)\.[А-ЯЁ][А-ЯЁа-яё]+"),
        СтрШаблон("Указан неверный Тип контейнера ""%1"".", полноеИмяМетаданных),
        получитьКонтекстДиагностики("ПолучитьМенеджерОбъектаПоСсылке"));

    имяТипаМенеджера = СтрЗаменить(полноеИмяМетаданных, ".", "Менеджер.");
    менеджерОбъекта = Новый(Тип(имяТипаМенеджера));

    Возврат менеджерОбъекта;
КонецФункции

// Параметры:
//	типПеречисления - Тип - Тип перечисления
//
// Возвращаемое значение:
//	Структура - Структура вида: { ИмяПеречисления, ЗначениеПеречисления }
//			  - Неопределено - Если указан неверный тип перечисления
Функция ПолучитьЗначенияПеречисления(Знач типПеречисления) Экспорт
    ДиагностикаКлиентСервер.Утверждение(типПеречисления <> Неопределено,
        "Аргумент ""ТипПеречисления"" должен иметь определенное значение.",
        получитьКонтекстДиагностики("ПолучитьЗначенияПеречисления"));

    метаданныеПеречисления = Метаданные.НайтиПоТипу(типПеречисления);
    Если метаданныеПеречисления = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Структура;
    Для Каждого значениеПеречисления Из метаданныеПеречисления.ЗначенияПеречисления Цикл
        имя = значениеПеречисления.Имя;
        значение = Перечисления[метаданныеПеречисления.Имя][имя];
        результат.Вставить(имя, значение);
    КонецЦикла;

    Возврат результат;
КонецФункции

// Параметры:
//	типКонтейнера - Тип - Тип контейнера (Справочник, ПланСчетов, ПланВидовРасчета, ПланВидовХарактеристик)
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - Структура вида: { ИмяПредопределенного, ЗначениеПредопределенного }
//			               - Неопределено - Если указан неверный тип перечисления
Функция ПолучитьЗначенияПредопределенных(Знач типКонтейнера) Экспорт
    ДиагностикаКлиентСервер.Утверждение(типКонтейнера <> Неопределено,
        "Аргумент ""ТипКонтейнера"" должен иметь определенное значение.",
        получитьКонтекстДиагностики("ПолучитьЗначенияПредопределенных"));

    метаданныеКонтейнера = Метаданные.НайтиПоТипу(типКонтейнера);
    Если метаданныеКонтейнера = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    менеджерОбъекта = ПолучитьМенеджерОбъекта(типКонтейнера);

    результат = Новый Структура;
    именаПредопределенных = метаданныеКонтейнера.ПолучитьИменаПредопределенных();
    Для Каждого имяПредопределенного Из именаПредопределенных Цикл
        результат.Вставить(имяПредопределенного, менеджерОбъекта[имяПредопределенного]);
    КонецЦикла;

    Возврат Новый ФиксированнаяСтруктура(результат);
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  имяФункции - Строка, Неопределено
// Возвращаемое значение:
//  - Строка
Функция получитьКонтекстДиагностики(Знач имяФункции = Неопределено)
    базовыйКонтекстДиагностики = "РаботаСМетаданными";
    Возврат ?(имяФункции = Неопределено, базовыйКонтекстДиагностики, СтрШаблон("%1.%2", базовыйКонтекстДиагностики, имяФункции));
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
