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
//	- ПеречислениеСсылка.ОплатаДокумента
//
Функция ПроверитьОплатуДокумента(Знач документРТУСсылка) Экспорт
	Если НЕ ЗначениеЗаполнено(документРТУСсылка) Тогда
		Возврат Перечисления.ОплатаДокумента.НеОплачен;
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
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ОплатаДокумента.ЧастичноОплачен)
		|		КОГДА ЕстьNULL(ВТ_Поступления.СуммаДокумента, 0) = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ОплатаДокумента.НеОплачен)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ОплатаДокумента.ПолностьюОплачен)
		|	КОНЕЦ КАК ПризнакОплаты
		|ИЗ
		|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Поступления КАК ВТ_Поступления
		|		ПО РеализацияТоваровИУслуг.Ссылка = ВТ_Поступления.ДокументОснование
		|ГДЕ
		|	РеализацияТоваровИУслуг.Ссылка = &Ссылка
		|";

	запрос.Текст = СтрШаблон("%1%2", текстЗапросаПоступленияДС, текстЗапросаПризнакОплаты);

	структураОтвета = Новый Структура("ПризнакОплаты, ОсталосьОплатить", Перечисления.ОплатаДокумента.НеОплачен, 0);

	выборка = запрос.Выполнить().Выбрать();
	выборка.Следующий();
	ЗаполнитьЗначенияСвойств(структураОтвета, выборка);
	Возврат структураОтвета;

КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
