﻿#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(_, __)
    выполнитьВсеДвижения();
КонецПроцедуры

Процедура ОбработкаЗаполнения(_, __)
    РаботаСДокументами.ЗаполнитьПолеАвторДокументаНаСервере(ЭтотОбъект);
КонецПроцедуры

Процедура ПередЗаписью(_, __, ___)
    Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;

    СуммаДокумента = Товары.Итог("Сумма");
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

#Область Движения
Процедура выполнитьВсеДвижения()
    Движения.ЦеныНоменклатурыПоставщиков.Записывать = Истина;
    Движения.ТоварыНаСкладах.Записывать = Истина;
    Движения.Хозрасчетный.Записывать = Истина;

    отражатьСрокиГодности = получитьУчетнуюПолитику() = Перечисления.ВидыУчетнойПолитики.FEFO;
    выборкаТоварыПоПартиям = получитьВыборкуТоварыПоПартиям();

    Пока выборкаТоварыПоПартиям.Следующий() Цикл
        выполнитьДвижениеЦеныНоменклатурыПоставщиков(выборкаТоварыПоПартиям.Номенклатура, выборкаТоварыПоПартиям.Цена);

        выборкаТовары = выборкаТоварыПоПартиям.Выбрать();
        Пока выборкаТовары.Следующий() Цикл
            выполнитьДвижениеТоварыНаСкладах(выборкаТовары, отражатьСрокиГодности);
            выполнитьДвижениеБУХозрасчетный(выборкаТовары.Номенклатура,
                выборкаТовары.СчетБухгалтерскогоУчета, выборкаТовары.Сумма);
        КонецЦикла;
    КонецЦикла;
КонецПроцедуры

Процедура выполнитьДвижениеБУХозрасчетный(Знач номенклатураСсылка, Знач счетДт, Знач сумма)
    движение = Движения.Хозрасчетный.Добавить();
    движение.СчетДт = счетДт;
    движение.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
    движение.Период = ЭтотОбъект.Дата;
    движение.Сумма = сумма;
    движение.Содержание = "Отражено поступление товарно-материальных ценностей от поставщика";
    движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура] = номенклатураСсылка;
    движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты] = ЭтотОбъект.Поставщик;
КонецПроцедуры

Процедура выполнитьДвижениеЦеныНоменклатурыПоставщиков(Знач номенклатураСсылка, Знач цена)
    движение = Движения.ЦеныНоменклатурыПоставщиков.Добавить();
    движение.Период = ЭтотОбъект.Дата;
    движение.Номенклатура = номенклатураСсылка;
    движение.Поставщик = ЭтотОбъект.Поставщик;
    движение.Цена = цена;
КонецПроцедуры

Процедура выполнитьДвижениеТоварыНаСкладах(текСтрокаТовары, Знач отражатьСрокиГодности = Ложь)
    движение = Движения.ТоварыНаСкладах.Добавить();
    движение.ВидДвижения = ВидДвиженияНакопления.Приход;
    движение.Период = ЭтотОбъект.Дата;
    движение.Номенклатура = текСтрокаТовары.Номенклатура;
    движение.Склад = ЭтотОбъект.Склад;
    движение.Количество = текСтрокаТовары.Количество;
    движение.Сумма = текСтрокаТовары.Сумма;
    Если отражатьСрокиГодности Тогда
        движение.СрокГодности = текСтрокаТовары.СрокГодности;
    КонецЕсли;
КонецПроцедуры
#КонецОбласти // Движения

Функция получитьВыборкуТоварыПоПартиям()
    запросТовары = Новый Запрос;
    запросТовары.УстановитьПараметр("Ссылка", Ссылка);

    запросТовары.Текст =
        "ВЫБРАТЬ
        |	ПоступлениеТоваровИМатериаловТовары.Номенклатура КАК Номенклатура,
        |	ПоступлениеТоваровИМатериаловТовары.Цена КАК Цена,
        |	СУММА(ПоступлениеТоваровИМатериаловТовары.Количество) КАК Количество,
        |	СУММА(ПоступлениеТоваровИМатериаловТовары.Сумма) КАК Сумма,
        |	ПоступлениеТоваровИМатериаловТовары.СрокГодности КАК СрокГодности,
        |	ТаблНоменклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
        |ИЗ
        |	Документ.ПоступлениеТоваровИМатериалов.Товары КАК ПоступлениеТоваровИМатериаловТовары
        |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК ТаблНоменклатура
        |		ПО (ТаблНоменклатура.Ссылка = ПоступлениеТоваровИМатериаловТовары.Номенклатура)
        |ГДЕ
        |	ПоступлениеТоваровИМатериаловТовары.Ссылка = &Ссылка
        |
        |СГРУППИРОВАТЬ ПО
        |	ПоступлениеТоваровИМатериаловТовары.Номенклатура,
        |	ПоступлениеТоваровИМатериаловТовары.Цена,
        |	ПоступлениеТоваровИМатериаловТовары.СрокГодности,
        |	ТаблНоменклатура.СчетБухгалтерскогоУчета
        |ИТОГИ
        |	МАКСИМУМ(Цена)
        |ПО
        |	Номенклатура
        |";

    Возврат запросТовары.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
КонецФункции

Функция получитьУчетнуюПолитику()
    Возврат РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(ЭтотОбъект.Дата).УчетнаяПолитика;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
