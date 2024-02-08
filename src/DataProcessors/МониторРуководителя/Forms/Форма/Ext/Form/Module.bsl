﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	инициализацияНаСервере();
	заполнитьДанныеНаСервере();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(_)
	заполнитьДанныеНаСервере();
	заполнитьПериодОбработкиНаСервере();
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МесяцСтрокойНажатие(_, стандартнаяОбработка)
	стандартнаяОбработка = Ложь;

	выбратьПериодОбработки();
	заполнитьДанныеНаСервере();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура заполнитьДанныеНаСервере()
	заполнитьЧисловыеПоказатели();
КонецПроцедуры

&НаКлиенте
Асинх Процедура выбратьПериодОбработки()
	подсказка = "Введите период получения данных";
	частьДаты = ЧастиДаты.Дата;
	результатДата = Ждать ВвестиДатуАсинх(ЭтотОбъект.ПериодОбработки, подсказка, частьДаты);
	Если результатДата <> Неопределено Тогда
		ЭтотОбъект.ПериодОбработки = НачалоМесяца(Результат);
		ЭтотОбъект.МесяцСтрокой = Формат(ЭтотОбъект.ПериодОбработки, получитьФорматПериода());
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура заполнитьПериодОбработкиНаСервере()
	ЭтотОбъект.ПериодОбработки = НачалоМесяца(ТекущаяДатаСеанса());
	ЭтотОбъект.МесяцСтрокой = Формат(ЭтотОбъект.ПериодОбработки, получитьФорматПериода());
КонецПроцедуры

&НаКлиенте
Функция получитьФорматПериода()
	Возврат "ДФ='ММММ гггг'";
КонецФункции

&НаКлиенте
Процедура заполнитьЧисловыеПоказатели(Знач датаНачала = Неопределено, Знач датаОкончания = Неопределено)
	датаНачала = ?(датаНачала = Неопределено, ЭтотОбъект.ПериодОбработки, датаНачала);
	датаОкончания = ?(датаОкончания = Неопределено, КонецМесяца(датаНачала), датаОкончания);

	результатПакет = получитьДанныеЧисловыхПоказателей(датаНачала, датаОкончания);

	ЭтотОбъект.ВсегоЗаписей = 0;

	выборкаПродажи = результатПакет[1].Выбрать();
	Если выборкаПродажи.Следующий() Тогда
		ЭтотОбъект.ВыручкаЧисло = выборкаПродажи.СуммаОборот;
	КонецЕсли;

	выборкаСреднийЧек = результатПакет[3].Выбрать();
	Если выборкаСреднийЧек.Следующий() Тогда
		ЭтотОбъект.СреднийЧек = выборкаСреднийЧек.СреднийЧек;
	КонецЕсли;

	выборкаЗаписиКлиентов = результатПакет[5].Выбрать();
	Если выборкаЗаписиКлиентов.Следующий() Тогда
		ЭтотОбъект.ВсегоЗаписей = выборкаЗаписиКлиентов.КоличествоЗаписейКлиентов;
	КонецЕсли;

	выборкаЗаписиКлиентовЗавершенные = результатПакет[6].Выбрать();
	Если выборкаЗаписиКлиентовЗавершенные.Следующий() Тогда
		ЭтотОбъект.Завершенных = выборкаЗаписиКлиентовЗавершенные.Завершенных;
		Если ЭтотОбъект.ВсегоЗаписей > 0 Тогда
			процентЗавершенных = ОКР((100 * Завершенных / ЭтотОбъект.ВсегоЗаписей), 2);
			ЭтотОбъект.ЗавершенныхПроцентСтрока = СтрШаблон("Это %1 процентов от всех записей", процентЗавершенных);
		Иначе
			ЗавершенныхПроцентСтрока = "В этом периоде нет записей клиентов!";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#Область ЗапросыДанных
&НаСервереБезКонтекста
Функция получитьДанныеЧисловыхПоказателей(Знач датаНачала, Знач датаОкончания)
	запрос = Новый Запрос;
	запрос.УстановитьПараметр("ДатаНачала", датаНачала);
	запрос.УстановитьПараметр("ДатаОкончания", датаОкончания);

	текстЗапросаПродажиИтоги =
		"ВЫБРАТЬ
		|	ПродажиОбороты.Регистратор КАК Регистратор,
		|	СУММА(ПродажиОбороты.СуммаОборот) КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	Регистратор
		|ИТОГИ
		|	КОЛИЧЕСТВО(Регистратор),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ
		|";

	текстЗапросаЗаписиКлиентов =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ЗаписиКлиентов.ЗаписьКлиента) КАК ВсегоЗаписей,
		|	КОЛИЧЕСТВО(ЗаписиКлиентов.КоличествоЗавершенных) КАК Завершенных,
		|	СУММА(ЗаписиКлиентов.Сумма) КАК СУММА
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЗаказыКлиентов.Регистратор КАК ЗаписьКлиента,
		|		ВЫБОР
		|			КОГДА НЕ РеализацияТоваровИУслуг.ДокументОснование ЕСТЬ NULL
		|				ТОГДА 1
		|		КОНЕЦ КАК КоличествоЗавершенных,
		|		МАКСИМУМ(РеализацияТоваровИУслуг.СуммаДокумента) КАК СУММА
		|	ИЗ
		|		РегистрНакопления.ЗаказыКлиентов КАК ЗаказыКлиентов
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
		|			ПО ЗаказыКлиентов.Регистратор = РеализацияТоваровИУслуг.ДокументОснование
		|	ГДЕ
		|		ЗаказыКлиентов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|			И ЗаказыКлиентов.Регистратор ССЫЛКА Документ.ЗаписьКлиента
		|
		|	СГРУППИРОВАТЬ ПО
		|		ЗаказыКлиентов.Регистратор,
		|		РеализацияТоваровИУслуг.ДокументОснование) КАК ЗаписиКлиентов
		|";

	запрос.Текст = СтрШаблон("%1;|%2",
			текстЗапросаПродажиИтоги,
			текстЗапросаВыполненныеЗаказы);

	результатПакет = запрос.ВыполнитьПакет();

	результат = Новый Структура;
	результат.Вставить("ПродажиИтоги", результатПакет[0]);
	результат.Вставить("ЗаписиКлиентов", результатПакет[1]);

	Возврат результатПакет;
КонецФункции
#КонецОбласти // ЗапросыДанных

#КонецОбласти // СлужебныеПроцедурыИФункции
