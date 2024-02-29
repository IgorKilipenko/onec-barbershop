﻿#Область ПрограммныйИнтерфейс
Процедура Печать(Знач табДок, Знач ссылка) Экспорт
    макет = Документы.РеализацияТоваровИУслуг.ПолучитьМакет("Печать");
    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ
        |	РеализацияТоваровИУслуг.АвторДокумента,
        |	РеализацияТоваровИУслуг.Дата,
        |	РеализацияТоваровИУслуг.ДатаОказанияУслуги,
        |	РеализацияТоваровИУслуг.Клиент,
        |	РеализацияТоваровИУслуг.Номер,
        |	РеализацияТоваровИУслуг.Сотрудник,
        |	РеализацияТоваровИУслуг.СуммаДокумента,
        |	РеализацияТоваровИУслуг.Услуги.(
        |		НомерСтроки,
        |		Номенклатура,
        |		Цена,
        |		Количество,
        |		Сумма
        |	),
        |	РеализацияТоваровИУслуг.Товары.(
        |		НомерСтроки,
        |		Номенклатура,
        |		Склад,
        |		Цена,
        |		Количество,
        |		Сумма
        |	)
        |ИЗ
        |	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
        |ГДЕ
        |	РеализацияТоваровИУслуг.Ссылка В (&Ссылка)
        |";

    запрос.Параметры.Вставить("Ссылка", ссылка);
    выборка = запрос.Выполнить().Выбрать();

    областьЗаголовок = макет.ПолучитьОбласть("Заголовок");
    шапка = макет.ПолучитьОбласть("Шапка");
    областьУслугиШапка = макет.ПолучитьОбласть("УслугиШапка");
    областьУслуги = макет.ПолучитьОбласть("Услуги");
    областьТоварыШапка = макет.ПолучитьОбласть("ТоварыШапка");
    областьТовары = макет.ПолучитьОбласть("Товары");
    подвал = макет.ПолучитьОбласть("Подвал");

    табДок.Очистить();

    вставлятьРазделительСтраниц = Ложь;
    Пока выборка.Следующий() Цикл
        Если вставлятьРазделительСтраниц Тогда
            табДок.ВывестиГоризонтальныйРазделительСтраниц();
        КонецЕсли;

        табДок.Вывести(областьЗаголовок);

        шапка.Параметры.Заполнить(выборка);
        табДок.Вывести(шапка, выборка.Уровень());

        выборкаУслуги = выборка.Услуги.Выбрать();
        Если выборкаУслуги.Количество() > 0 Тогда
            табДок.Вывести(областьУслугиШапка);
            Пока выборкаУслуги.Следующий() Цикл
                областьУслуги.Параметры.Заполнить(выборкаУслуги);
                табДок.Вывести(областьУслуги, выборкаУслуги.Уровень());
            КонецЦикла;
        КонецЕсли;

        выборкаТовары = выборка.Товары.Выбрать();
        Если выборкаТовары.Количество() > 0 Тогда
            табДок.Вывести(областьТоварыШапка);
            Пока выборкаТовары.Следующий() Цикл
                областьТовары.Параметры.Заполнить(выборкаТовары);
                табДок.Вывести(областьТовары, выборкаТовары.Уровень());
            КонецЦикла;
        КонецЕсли;

        подвал.Параметры.Заполнить(выборка);
        табДок.Вывести(подвал);

        вставлятьРазделительСтраниц = Истина;
    КонецЦикла;
КонецПроцедуры

// Устарело. В текущей реализации не используется
// Получает связанные документы поступления денежных средств (ПДС)
//
// Параметры:
//	документРТУСсылка - ДокументСсылка.РеализацияТоваровИУслуг
//	дополнительныеПоля - Массив, Неопределено - список имен дополнительных полей
//	толькоПроведенные - Булево - если Истина, будет установлен фильтр: ПоступлениеДенежныхСредств.Проведен
//	менеджерТаблиц - МенеджерВременныхТаблиц, Неопределено - если указан МенеджерТаблиц результат будет помещен в ВТ_ПоступленияДС
//
// Возвращаемое значение:
//	- Выборка, РезультатЗапроса - если в параметрах указан МенеджерВременныхТаблиц - вернет РезультатЗапроса, иначе Выборка
//
Функция ПолучитьСвязанныеДокументыПДС(Знач документРТУСсылка, Знач дополнительныеПоля = Неопределено,
        Знач толькоПроведенные = Истина, менеджерТаблиц = Неопределено) Экспорт
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("Ссылка", документРТУСсылка);

    текстЗапроса =
        "ВЫБРАТЬ
        |	ПоступлениеДенежныхСредств.Ссылка КАК Ссылка
        |	{ДополнительныеПоля}
        |ПОМЕСТИТЬ ВТ_ПоступленияДС
        |ИЗ
        |	Документ.ПоступлениеДенежныхСредств КАК ПоступлениеДенежныхСредств
        |ГДЕ
        |	ПоступлениеДенежныхСредств.ДокументОснование = &Ссылка
        |		И ПоступлениеДенежныхСредств.Проведен
        |";

    Если менеджерТаблиц = Неопределено Тогда
        запрос.МенеджерВременныхТаблиц = менеджерТаблиц;
    Иначе
        текстЗапроса = СтрЗаменить(текстЗапроса, "ПОМЕСТИТЬ ВТ_Поступления", "");
    КонецЕсли;

    Если НЕ толькоПроведенные Тогда
        текстЗапроса = СтрЗаменить(текстЗапроса, "И ПоступлениеДенежныхСредств.Проведен", "");
    КонецЕсли;

    Если дополнительныеПоля <> Неопределено И дополнительныеПоля.Количество() > 0 Тогда
        стрДопПоля = "";
        Для Каждого поле Из дополнительныеПоля Цикл
            стрДопПоля = стрДопПоля + СтрШаблон("|, ПоступлениеДенежныхСредств.%1 КАК %1", поле);
        КонецЦикла;
        текстЗапроса = СтрЗаменить(текстЗапроса, "{ДополнительныеПоля}", стрДопПоля);
    Иначе
        текстЗапроса = СтрЗаменить(текстЗапроса, "{ДополнительныеПоля}",
                ?(толькоПроведенные, "", "|, ПоступлениеДенежныхСредств.Проведен КАК Проведен"));
    КонецЕсли;

    запрос.Текст = текстЗапроса;

    результатЗапроса = запрос.Выполнить();

    Если менеджерТаблиц <> Неопределено Тогда
        Возврат результатЗапроса;
    КонецЕсли;

    Возврат результатЗапроса.Выбрать();

КонецФункции

// Параметры:
//	документРТУСсылка - ДокументСсылка.РеализацияТоваровИУслуг
//
// Возвращаемое значение:
//	- Структура - { ПризнакОплаты: ПеречислениеСсылка.ПризнакиОплаты, ОсталосьОплатить: Число | Неопределено }
//
Функция ПроверитьОплатуДокумента(Знач документРТУСсылка) Экспорт
    структураОтвета = Новый Структура("ПризнакОплаты, ОсталосьОплатить", Перечисления.ПризнакиОплаты.НеОплачен, Неопределено);

    Если НЕ ЗначениеЗаполнено(документРТУСсылка) Тогда
        Возврат структураОтвета;
    КонецЕсли;

    запрос = Новый Запрос;
    запрос.УстановитьПараметр("Ссылка", документРТУСсылка);

    текстЗапросаПоступленияДС =
        "ВЫБРАТЬ
        |	СУММА(ПоступлениеДенежныхСредств.СуммаДокумента) КАК СуммаДокумента,
        |	ПоступлениеДенежныхСредств.ДокументОснование КАК ДокументОснование
        |ПОМЕСТИТЬ ВТ_Поступления
        |ИЗ
        |	Документ.ПоступлениеДенежныхСредств КАК ПоступлениеДенежныхСредств
        |ГДЕ
        |	ПоступлениеДенежныхСредств.ДокументОснование = &Ссылка
        |		И ПоступлениеДенежныхСредств.Проведен
        |
        |СГРУППИРОВАТЬ ПО
        |	ПоступлениеДенежныхСредств.ДокументОснование
        |;";

    текстЗапросаПризнакОплаты =
        "ВЫБРАТЬ
        |	РеализацияТоваровИУслуг.СуммаДокумента - ЕстьNULL(ВТ_Поступления.СуммаДокумента, 0) КАК ОсталосьОплатить,
        |	ВЫБОР
        |		КОГДА РеализацияТоваровИУслуг.СуммаДокумента - ЕстьNULL(ВТ_Поступления.СуммаДокумента, 0) > 0
        |			И ЕстьNULL(ВТ_Поступления.СуммаДокумента, 0) > 0
        |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакиОплаты.ЧастичноОплачен)
        |		КОГДА ЕстьNULL(ВТ_Поступления.СуммаДокумента, 0) = 0
        |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПризнакиОплаты.НеОплачен)
        |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПризнакиОплаты.ПолностьюОплачен)
        |	КОНЕЦ КАК ПризнакОплаты
        |ИЗ
        |	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Поступления КАК ВТ_Поступления
        |		ПО РеализацияТоваровИУслуг.Ссылка = ВТ_Поступления.ДокументОснование
        |ГДЕ
        |	РеализацияТоваровИУслуг.Ссылка = &Ссылка
        |";

    запрос.Текст = СтрШаблон("%1%2", текстЗапросаПоступленияДС, текстЗапросаПризнакОплаты);

    структураОтвета = Новый Структура("ПризнакОплаты, ОсталосьОплатить", Перечисления.ПризнакиОплаты.НеОплачен, 0);

    выборка = запрос.Выполнить().Выбрать();
    выборка.Следующий();
    ЗаполнитьЗначенияСвойств(структураОтвета, выборка);
    Возврат структураОтвета;

КонецФункции

#Область ЗапросыДанных
Функция ПолучитьВыборкуДокументНоменклатураОстатки(Знач документРТУСсылка, Знач моментВремени, Знач менеджерТаблиц) Экспорт
    запросОстатков = Новый Запрос;
    запросОстатков.МенеджерВременныхТаблиц = менеджерТаблиц;
    запросОстатков.УстановитьПараметр("Ссылка", документРТУСсылка);
    запросОстатков.УстановитьПараметр("МоментВремени", моментВремени);

    текстЗапросаТоваровИУслугДокумента =
        "ВЫБРАТЬ
        |	РеализацияТоваровИУслугТовары.Номенклатура КАК Номенклатура,
        |	РеализацияТоваровИУслугТовары.Склад КАК Склад,
        |	СУММА(РеализацияТоваровИУслугТовары.Количество) КАК Количество,
        |	СУММА(РеализацияТоваровИУслугТовары.Сумма) КАК Сумма
        |ПОМЕСТИТЬ ВТ_Товары
        |ИЗ
        |	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
        |ГДЕ
        |	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
        |
        |СГРУППИРОВАТЬ ПО
        |	РеализацияТоваровИУслугТовары.Номенклатура,
        |	РеализацияТоваровИУслугТовары.Склад
        |
        |ОБЪЕДИНИТЬ ВСЕ
        |
        |ВЫБРАТЬ
        |	РеализацияТоваровИУслугУслуги.Номенклатура,
        |	NULL,
        |	СУММА(РеализацияТоваровИУслугУслуги.Количество),
        |	СУММА(РеализацияТоваровИУслугУслуги.Сумма)
        |ИЗ
        |	Документ.РеализацияТоваровИУслуг.Услуги КАК РеализацияТоваровИУслугУслуги
        |ГДЕ
        |	РеализацияТоваровИУслугУслуги.Ссылка = &Ссылка
        | СГРУППИРОВАТЬ ПО
        |	РеализацияТоваровИУслугУслуги.Номенклатура
        |
        |ИНДЕКСИРОВАТЬ ПО
        |	Номенклатура,
        |	Склад
        |;
        |";

    текстЗапросаОстатков =
        "ВЫБРАТЬ
        |	ВТ_Товары.Номенклатура КАК Номенклатура,
        |	ВЫБОР
        |		КОГДА ВТ_Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
        |			ТОГДА ЛОЖЬ
        |		ИНАЧЕ ИСТИНА
        |	КОНЕЦ КАК ЭтоТовар,
        |	ВТ_Товары.Номенклатура.Представление КАК НоменклатураПредставление,
        |	ВТ_Товары.Количество КАК КоличествоВДокументе,
        |	ВТ_Товары.Сумма КАК СуммаВДокументе,
        |	ВТ_Товары.Склад КАК Склад,
        |	ТоварыНаСкладахОстатки.СрокГодности КАК СрокГодности,
        |	ЕстьNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
        |	ЕстьNULL(ТоварыНаСкладахОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
        |	ВТ_Товары.Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат,
        |   ВТ_Товары.Номенклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
        |ИЗ
        |	ВТ_Товары КАК ВТ_Товары
        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(
        |			&МоментВремени,
        |			(Номенклатура, Склад) В (
        |				ВЫБРАТЬ
        |					ВТ_Товары.Номенклатура,
        |					ВТ_Товары.Склад
        |				ИЗ
        |					ВТ_Товары КАК ВТ_Товары)) КАК ТоварыНаСкладахОстатки
        |		ПО ВТ_Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
        |			И ВТ_Товары.Склад = ТоварыНаСкладахОстатки.Склад
        |
        |УПОРЯДОЧИТЬ ПО
        |	ТоварыНаСкладахОстатки.СрокГодности
        |ИТОГИ
        |	МАКСИМУМ(КоличествоВДокументе),
        |	МАКСИМУМ(СуммаВДокументе),
        |	СУММА(КоличествоОстаток)
        |ПО
        |	Номенклатура
        |";

    запросОстатков.Текст = СтрШаблон("%1%2", текстЗапросаТоваровИУслугДокумента, текстЗапросаОстатков);

    Возврат запросОстатков.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
КонецФункции

Функция ПолучитьВыборкуПревышенияОстатковЗаказыКлиентов(
        Знач датаОказанияУслуги, Знач клиент, Знач моментВремени, Знач менеджерТаблиц) Экспорт

    запросЗаказыКлиентовОстатки = Новый Запрос;
    запросЗаказыКлиентовОстатки.МенеджерВременныхТаблиц = менеджерТаблиц;

    запросЗаказыКлиентовОстатки.УстановитьПараметр("МоментВремени", моментВремени);
    запросЗаказыКлиентовОстатки.УстановитьПараметр("Клиент", клиент);
    запросЗаказыКлиентовОстатки.УстановитьПараметр("ДатаЗаписи", датаОказанияУслуги);

    запросЗаказыКлиентовОстатки.Текст =
        "ВЫБРАТЬ
        |	ЗаказыКлиентовОстатки.КоличествоОстаток КАК КоличествоОстаток,
        |	ЗаказыКлиентовОстатки.Клиент КАК Клиент,
        |	ЗаказыКлиентовОстатки.ДатаЗаписи КАК ДатаЗаписи,
        |	ЗаказыКлиентовОстатки.Клиент.Представление КАК КлиентПредставление,
        |	ЗаказыКлиентовОстатки.Номенклатура КАК Номенклатура,
        |	ЗаказыКлиентовОстатки.Номенклатура.Представление КАК НоменклатураПредставление
        |ИЗ
        |	РегистрНакопления.ЗаказыКлиентов.Остатки(
        |			&МоментВремени,
        |			Клиент = &Клиент
        |				И ДатаЗаписи = &ДатаЗаписи
        |				И Номенклатура В
        |					(ВЫБРАТЬ
        |						ВТ_Товары.Номенклатура
        |					ИЗ
        |						ВТ_Товары КАК ВТ_Товары
        |					ГДЕ
        |						ВТ_Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга))) КАК ЗаказыКлиентовОстатки
        |ГДЕ
        |	ЗаказыКлиентовОстатки.КоличествоОстаток < 0
        |";

    результатЗапроса = запросЗаказыКлиентовОстатки.Выполнить();
    Возврат ?(результатЗапроса.Пустой(), Неопределено, результатЗапроса.Выбрать());
КонецФункции
#КонецОбласти // ЗапросыДанных

#КонецОбласти // ПрограммныйИнтерфейс
