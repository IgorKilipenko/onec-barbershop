﻿#Область ПрограммныйИнтерфейс

Функция ПолучитьОстатокПоКассе(Знач кассаСсылка, Знач моментВремени = Неопределено) Экспорт
    Возврат получитьОстатокПо(кассаСсылка, моментВремени);
КонецФункции

Функция ПолучитьОстатокПоРасчетномуСчету(Знач расчетныйСчетСсылка, Знач моментВремени = Неопределено) Экспорт
    Возврат получитьОстатокПо(расчетныйСчетСсылка, моментВремени);
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция получитьОстатокПо(Знач расчетныйСчетИлиКассаСсылка, Знач моментВремени = Неопределено)
    этоКасса = ТипЗнч(расчетныйСчетИлиКассаСсылка) = Тип("СправочникСсылка.Касса");
    этоРасчетныйСчет = ТипЗнч(расчетныйСчетИлиКассаСсылка) = Тип("СправочникСсылка.БанковскиеСчета");

    ДиагностикаКлиентСервер.Утверждение(этоКасса ИЛИ этоРасчетныйСчет,
        "Неверное значение аргумента ""РасчетныйСчетИлиКассаСсылка"", значение должно иметь тип в диапазоне: [
        |   ""СправочникСсылка.Касса"",
        |   ""СправочникСсылка.БанковскиеСчета""
        |]");

    запросОстаткиДС = Новый Запрос;
    запросОстаткиДС.Текст = сформироватьЗапросНаПолучениеОстаткаПо(этоКасса, моментВремени <> Неопределено);

    имяИзмерения = ?(этоКасса, "Касса", "РасчетныйСчет");
    запросОстаткиДС.УстановитьПараметр(имяИзмерения, расчетныйСчетИлиКассаСсылка);

    Если моментВремени <> Неопределено Тогда
        запросОстаткиДС.УстановитьПараметр("МоментВремени", моментВремени);
    КонецЕсли;

    результатЗапроса = запросОстаткиДС.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Структура(СтрШаблон("%1, Сумма", имяИзмерения));
    выборка = результатЗапроса.Выбрать();
    выборка.Следующий();
    ЗаполнитьЗначенияСвойств(результат, выборка);
    Возврат выборка;
КонецФункции

Функция сформироватьЗапросНаПолучениеОстаткаПо(Знач этоКасса = Ложь, Знач наМоментВремени = Ложь)
    результат =
        "ВЫБРАТЬ
        |	ДенежныеСредстваОстатки.БанковскийСчетКасса.Представление КАК РасчетныйСчет,
        |	ДенежныеСредстваОстатки.СуммаОстаток КАК Сумма
        |ИЗ
        |	РегистрНакопления.ДенежныеСредства.Остатки(
        |		&МоментВремени,
        |		БанковскийСчетКасса = &РасчетныйСчет
        |			И ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)) КАК ДенежныеСредстваОстатки
        |";

    Если этоКасса Тогда
        результат = СтрЗаменить(результат, "РасчетныйСчет", "Касса");
        результат = СтрЗаменить(результат, "Безналичные", "Наличные");
    КонецЕсли;

    Если НЕ наМоментВремени Тогда
        результат = СтрЗаменить(результат, "&МоментВремени", "");
    КонецЕсли;

    Возврат результат;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
