﻿#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
//	- Структура
Функция ПолучитьВидыОперацийСписанияСРасчетногоСчета() Экспорт
    Возврат РаботаСМетаданными.ПолучитьЗначенияПеречисления(Тип("ПеречислениеСсылка.ВидыОперацийСписанияСРасчетногоСчета"));
КонецФункции

// Параметры:
//  видОперации - ПеречислениеСсылка.ВидыОперацийСписанияСРасчетногоСчета
//  значенияПолей - Структура, ФиксированнаяСтруктура - Структура вида: { Получатель, РасчетныйСчет }
// Возвращаемое значение:
//	- Структура
Функция ПолучитьАналитикуПроводки(Знач видОперации, Знач значенияПолей) Экспорт
    БУ = БухгалтерскийУчет;
    структураАналитики = БУ.СоздатьСтруктуруАналитикиПроводки(Неопределено,
            БУ.СоздатьОписаниеСчета(ПланыСчетов.Хозрасчетный.РасчетныеСчета, значенияПолей.РасчетныйСчет));

    Если видОперации = Перечисления.ВидыОперацийСписанияСРасчетногоСчета.ОплатаПоставщику Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Оплата поставщику с расчетного счета";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийСписанияСРасчетногоСчета.ВозвратПокупателю Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПокупателями;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Возврат средств покупателю с расчетного счета";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийСписанияСРасчетногоСчета.ПеречислениеПодотчетномуЛицу Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Перечисление подотченику с расчетного счета";

    ИначеЕсли видОперации = Перечисления.ВидыОперацийСписанияСРасчетногоСчета.ПеречислениеЗаработнойПлаты Тогда
        структураАналитики.Дебет.Счет = ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда;
        структураАналитики.Дебет.Субконто = значенияПолей.Получатель;
        структураАналитики.СодержаниеОперации = "Выплата заработной платы на счет сотрудника";

    Иначе
        ВызватьИсключение "Недопустимый вид операции.";
    КонецЕсли;

    Возврат структураАналитики;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
