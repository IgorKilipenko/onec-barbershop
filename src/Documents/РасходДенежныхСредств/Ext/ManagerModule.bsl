﻿#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
//	- Структура
Функция ПолучитьРасходДенежныхСредств() Экспорт
    Возврат РаботаСМетаданными.ПолучитьЗначенияПеречисления(Тип("ПеречислениеСсылка.ВидыОперацийРасходаДенег"));
КонецФункции

// Параметры:
//  видОперации - ПеречислениеСсылка.ВидыОперацийРасходаДенег
//  значенияПолей - Структура, ФиксированнаяСтруктура - Структура вида: { Получатель, РасчетныйСчет, Касса }
// Возвращаемое значение:
//	- Структура
Функция ПолучитьАналитикуПроводки(Знач видОперации, Знач значенияПолей) Экспорт
    БУ = БухгалтерскийУчет;
    структураАналитики = БУ.СоздатьСтруктуруАналитикиПроводки(Неопределено,
            БУ.СоздатьОписаниеСчета(ПланыСчетов.Хозрасчетный.Касса, значенияПолей.Касса));

    Если видОперации = Перечисления.ВидыОперацийРасходаДенег.ОплатаПоставщику Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Оплата поставщику наличными из кассы";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийРасходаДенег.ВозвратДенегПокупателю Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПокупателями;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Возврат покупателю наличными из кассы";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийРасходаДенег.ВыдачаДенегПодотчетнику Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Выдача в подотчет наличных из кассы";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийРасходаДенег.ВзносНаличнымиВБанк Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетныеСчета;
        структураАналитики.Дебет.Субконто = значенияПолей.РасчетныйСчет;
        структураАналитики.СодержаниеОперации = "Взнос наличными в банк";

    Иначе
        ВызватьИсключение "Недопустимый вид операции.";
    КонецЕсли;

    Возврат структураАналитики;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
