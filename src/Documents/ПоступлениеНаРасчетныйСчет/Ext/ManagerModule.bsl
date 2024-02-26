﻿#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
//	- Структура
Функция ПолучитьВидыОперацийПоступленияНаРасчетныйСчет() Экспорт
	Возврат РаботаСМетаданными.ПолучитьЗначенияПеречисления(Тип("ПеречислениеСсылка.ВидыОперацийПоступленияНаРасчетныйСчет"));
КонецФункции

// Возвращаемое значение:
//	- СправочникСсылка.Кассы, Неопределено
Функция ПолучитьКассуПоУмолчанию() Экспорт
	Возврат Справочники.Кассы.ПолучитьОсновнуюКассу();
КонецФункции

// Параметры:
//  видОперации - ПеречислениеСсылка.ВидыОперацийПоступленияНаРасчетныйСчет
//  значенияПолей - Структура, ФиксированнаяСтруктура - Структура вида: { Плательщик, ЭквайринговыйТерминал, РасчетныеСчета }
// Возвращаемое значение:
//	- Структура
Функция ПолучитьАналитикуПроводки(Знач видОперации, Знач значенияПолей) Экспорт
    БУ = БухгалтерскийУчет;
    структураАналитики = БУ.СоздатьСтруктуруАналитикиПроводки(
        БУ.СоздатьОписаниеСчета(ПланыСчетов.Хозрасчетный.РасчетныеСчета, значенияПолей.РасчетныйСчет));

    Если видОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаОтПокупателя Тогда
        структураАналитики.Кредит.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПокупателями;
        структураАналитики.Кредит.Субконто = значенияПолей.Плательщик;
        структураАналитики.СодержаниеОперации = "Оплата от покупателя на расчетный счет";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика Тогда
        структураАналитики.Кредит.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
        структураАналитики.Кредит.Субконто = значенияПолей.Плательщик;
        структураАналитики.СодержаниеОперации = "Возврат средств поставщику с расчетного счета";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаПоБанковскимКартам Тогда
        структураАналитики.Кредит.Счет = ПланыСчетов.Хозрасчетный.ПереводыВПути;
        структураАналитики.Кредит.Субконто = значенияПолей.ЭквайринговыйТерминал;
        структураАналитики.СодержаниеОперации = "Получение наличных денег с расчетного счета в кассу";

    Иначе
        ВызватьИсключение "Недопустимый вид операции.";
    КонецЕсли;

    Возврат структураАналитики;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
