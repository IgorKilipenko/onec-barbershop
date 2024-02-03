﻿#Область ОписаниеПеременных

&НаКлиенте
Перем _ТипыДенежныхСредств;

&НаКлиенте
Перем _ВидыОперацийПоступленияДенег;

&НаКлиенте
Перем _ПоляИзменяющиеТипФормы;

&НаКлиенте
Перем _НастраиваемыеПоляФормы;

&НаКлиенте
Перем _ТипДенежныхСредствБуфер;

&НаКлиенте
Перем _ВидОперацииБуфер;

&НаКлиенте
Перем _ПлательщикБуфер;

&НаКлиенте
Перем _СкрываемыеРеквизиты;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	инициализацияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(_)
	инициализация();
	установитьВидимостьПолейФормы(Элементы.ТипДенежныхСредств);
	установитьВидимостьПолейФормы(Элементы.ВидОперации);
	установитьВидимостьПолейФормы(Элементы.Плательщик);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(_)
	изменитьТипФормы(_ПоляИзменяющиеТипФормы.ТипДенежныхСредств);
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(_)
	изменитьТипФормы(_ПоляИзменяющиеТипФормы.ВидОперации);
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(_)
	изменитьТипФормы(_ПоляИзменяющиеТипФормы.Плательщик);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура установитьВидимостьПолейФормы(полеИсточникСобытия)
	настройкиПолей = получитьСкрываемыеПоля(полеИсточникСобытия);
	Для Каждого поле Из настройкиПолей.СкрываемыеПоля Цикл
		поле.Видимость = Ложь;
	КонецЦикла;

	Для Каждого поле Из настройкиПолей.ОтображаемыеПоля Цикл
		поле.Видимость = Истина;
	КонецЦикла;
КонецПроцедуры

// Возвращаемое значение:
//	- Строка
//	- Неопределено
&НаКлиенте
Функция получитьПредставлениеТипаПлательщика() // => Строка | Неопределено
	Если Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПрочееПоступление Тогда
		Возврат Неопределено;
	КонецЕсли;

	строкаТипПлательщика = Неопределено;
	Если Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника Тогда
		строкаТипПлательщика = "СправочникСсылка.Сотрудники";

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке Тогда
		строкаТипПлательщика = "СправочникСсылка.Банки";
	Иначе
		строкаТипПлательщика = "СправочникСсылка.Контрагенты";
	КонецЕсли;

	Возврат строкаТипПлательщика;
КонецФункции

&НаКлиенте
Процедура изменитьТипФормы(Знач имяИзмененногоРеквизита)
	Если имяИзмененногоРеквизита = "ТипДенежныхСредств" Тогда
		изменитьТипДенежныхСредствФормы();
	ИначеЕсли имяИзмененногоРеквизита = "ВидОперации" Тогда
		показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииВидаОперации("_приЗапросеНаИзменениеВидаОперации_ОВ");
	ИначеЕсли имяИзмененногоРеквизита = "Плательщик" Тогда
		показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииПлательщика("_приЗапросеНаИзменениеПлательщика_ОВ");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция сформироватьТекстЗапросаОчисткиПолей(Знач имяРеквизита, поляДляОчистки) // => Строка | Неопределено
	Если поляДляОчистки = Неопределено ИЛИ поляДляОчистки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	текстВопроса_ = СтрШаблон("При изменении реквизита ""%1"" будут очищены следующие данные:", имяРеквизита);

	Для Каждого поле Из поляДляОчистки Цикл
		текстВопроса_ = текстВопроса_ + "
			| - %1";

		текстВопроса_ = СтрШаблон(текстВопроса_, поле);
	КонецЦикла;

	Если ЗначениеЗаполнено(поляДляОчистки) Тогда
		текстВопроса_ = текстВопроса_ + "
			| Продолжить?";
	Иначе
		текстВопроса_ = Неопределено;
	КонецЕсли;

	Возврат текстВопроса_;
КонецФункции

// Открывает форму диалогового окна для подтверждения очистки ранее заполненных значений полей формы.\
// Вызывается при изменении значения поля формы: ТипаДенежныхСредств
//
// Параметры:
//	обратныйВызов - Строка - имя функции обратного вызова для обработки события: закрытие диалогового окна
//		по умолчанию - _приЗапросеНаИзменениеТипаДенежныхСредств_ОВ
&НаКлиенте
Асинх Процедура изменитьТипДенежныхСредствФормы()
	имяРеквизита = _ПоляИзменяющиеТипФормы.ТипДенежныхСредств;
	поляДляОчистки = Новый Массив;

	Если этоОплатаНаличными() И ЗначениеЗаполнено(Объект.ЭквайринговыйТерминал) Тогда
		поляДляОчистки.Добавить("ЭквайринговыйТерминал");
	ИначеЕсли этоОплатаБезналичными() И ЗначениеЗаполнено(Объект.Касса) Тогда
		поляДляОчистки.Добавить("Касса");
	КонецЕсли;

	текстВопроса = сформироватьТекстЗапросаОчисткиПолей(имяРеквизита, поляДляОчистки);
	нужноОчиститьПоля = ЗначениеЗаполнено(текстВопроса);
	отменитьИзменение = Ложь;

	Если нужноОчиститьПоля Тогда
		кодВозврата = Ждать ВопросАсинх(текстВопроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
		отменитьИзменение = кодВозврата <> КодВозвратаДиалога.Да;

		Если НЕ отменитьИзменение Тогда
			очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		КонецЕсли;
	КонецЕсли;

	Если нужноОчиститьПоля И отменитьИзменение Тогда // Возврат значений полей (отмена очистки)
		Объект.ТипДенежныхСредств = _ТипДенежныхСредствБуфер;

	Иначе // Применить изменения
		_ТипДенежныхСредствБуфер = Объект.ТипДенежныхСредств;
		установитьВидимостьПолейФормы(Элементы.ТипДенежныхСредств);
	КонецЕсли;

КонецПроцедуры

// Открывает форму диалогового окна для подтверждения очистки ранее заполненных значений полей формы.\
// Вызывается при изменении значения поля формы: ВидаОперации
//
// Параметры:
//	обратныйВызов - Строка - имя функции обратного вызова для обработки события: закрытие диалогового окна
&НаКлиенте
Процедура показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииВидаОперации(обратныйВызов = "_приЗапросеНаИзменениеВидаОперации_ОВ")
	имяРеквизита = "ВидОперации";
	массивОчищаемыхРеквизитов = Новый Массив;

	одноИзОчищаемыхПолейЗаполнено = ЗначениеЗаполнено(Объект.Плательщик) ИЛИ ЗначениеЗаполнено(Объект.ДоговорКонтрагента);

	Если одноИзОчищаемыхПолейЗаполнено Тогда
		Если (этоВозвратОтПодотчетника() ИЛИ этоПолучениеНаличныхВБанке()) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			массивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");

		ИначеЕсли этоПрочееПоступление() Тогда
			Если ЗначениеЗаполнено(Объект.Плательщик) Тогда
				массивОчищаемыхРеквизитов.Добавить("Плательщик");
			КонецЕсли;
			Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
				массивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	текстВопроса = сформироватьТекстЗапросаОчисткиПолей(имяРеквизита, массивОчищаемыхРеквизитов);

	Если текстВопроса <> Неопределено Тогда
		оповещение = Новый ОписаниеОповещения(обратныйВызов, ЭтотОбъект, массивОчищаемыхРеквизитов);
		ПоказатьВопрос(оповещение, текстВопроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
	Иначе
		// Поля для очистки не заполнены или ВидОперации не входит в диапазон значений
		_ВидОперацииБуфер = Объект.ВидОперации;
		установитьВидимостьПолейФормы(Элементы.ВидОперации);
		Возврат; // Оповещение пользователю не показываем
	КонецЕсли;
КонецПроцедуры

// Открывает форму диалогового окна для подтверждения очистки ранее заполненных значений полей формы.\
// Вызывается при изменении значения поля формы: Плательщик
//
// Параметры:
//	обратныйВызов - Строка - имя функции обратного вызова для обработки события: закрытие диалогового окна
&НаКлиенте
Процедура показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииПлательщика(обратныйВызов = "_приЗапросеНаИзменениеПлательщика_ОВ")
	имяРеквизита = "Плательщик";
	массивОчищаемыхРеквизитов = Новый Массив;

	этоКлиент = этоКлиент(Объект.Плательщик);
	массивОчищаемыхРеквизитов = Новый Массив;

	Если этоКлиент И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		массивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;

	текстВопроса = сформироватьТекстЗапросаОчисткиПолей(имяРеквизита, массивОчищаемыхРеквизитов);

	Если текстВопроса <> Неопределено Тогда
		оповещение = Новый ОписаниеОповещения(обратныйВызов, ЭтотОбъект, массивОчищаемыхРеквизитов);
		ПоказатьВопрос(оповещение, текстВопроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
	Иначе
		_ПлательщикБуфер = Объект.Плательщик;
		установитьВидимостьПолейФормы(Элементы.Плательщик);
	КонецЕсли;
КонецПроцедуры

// Выполняет очистку ранее заполненных значений полей формы
//
// Параметры:
//	поляДляОчистки - Массив - Массив имен полей (реквизитов) для очистки
&НаКлиенте
Процедура очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки)
	Для Каждого имяРеквизита Из поляДляОчистки Цикл
		Объект[имяРеквизита] = Неопределено;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция получитьСкрываемыеПоля(полеИсточникСобытия, типОплаты = Неопределено,
		видОперации = Неопределено, плательщик = Неопределено)

	Если полеИсточникСобытия = Элементы.ТипДенежныхСредств Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииТипаОплаты(типОплаты);

	ИначеЕсли полеИсточникСобытия = Элементы.ВидОперации Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииВидаОперации(видОперации);

	ИначеЕсли полеИсточникСобытия = Элементы.Плательщик Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииПлательщика(плательщик);
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииТипаОплаты(типОплаты = Неопределено)
	скрываемыеПоля = Новый Соответствие;
	изменяемыеПоля = Новый Массив;

	изменяемыеПоля.Добавить(Элементы.Касса);
	изменяемыеПоля.Добавить(Элементы.ЭквайринговыйТерминал);

	типОплаты = ?(типОплаты = Неопределено, Объект.ТипДенежныхСредств, типОплаты);
	Если типОплаты = _ТипыДенежныхСредств.Наличные Тогда
		скрываемыеПоля.Вставить(Элементы.ЭквайринговыйТерминал.Имя, Элементы.ЭквайринговыйТерминал);

	ИначеЕсли типОплаты = _ТипыДенежныхСредств.Безналичные Тогда
		скрываемыеПоля.Вставить(Элементы.Касса.Имя, Элементы.Касса);
	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(скрываемыеПоля, изменяемыеПоля, Неопределено);
КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииВидаОперации(видОперации = Неопределено)
	скрываемыеПоля = Новый Соответствие;
	изменяемыеПоля = Новый Массив;
	типПолучателя = Неопределено;

	изменяемыеПоля.Добавить(Элементы.ДоговорКонтрагента);
	изменяемыеПоля.Добавить(Элементы.Плательщик);

	видОперации = ?(видОперации = Неопределено, Объект.ВидОперации, видОперации);
	Если видОперации = _ВидыОперацийПоступленияДенег.ПрочееПоступление Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		скрываемыеПоля.Вставить(Элементы.Плательщик.Имя, Элементы.Плательщик);

	ИначеЕсли видОперации = _ВидыОперацийПоступленияДенег.ОплатаОтПокупателя Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПолучателя = Тип("СправочникСсылка.Контрагенты");
	ИначеЕсли видОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПоставщика Тогда
		типПолучателя = Тип("СправочникСсылка.Контрагенты");

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПолучателя = Тип("СправочникСсылка.Сотрудники");

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПолучателя = Тип("СправочникСсылка.Банки");

	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(скрываемыеПоля, изменяемыеПоля, типПолучателя);
КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииПлательщика(плательщик = Неопределено)
	скрываемыеПоля = Новый Соответствие;
	изменяемыеПоля = Новый Массив;

	изменяемыеПоля.Добавить(Элементы.ДоговорКонтрагента);

	плательщик = ?(плательщик = Неопределено, Объект.Плательщик, плательщик);
	Если этоКлиент(плательщик) Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(скрываемыеПоля, изменяемыеПоля, Неопределено);
КонецФункции

&НаКлиенте
Функция создатьОбъектПараметровНастраиваемогоПоля(скрываемыеПоля, изменяемыеПоля, типПолучателя)
	отображаемыеПоля = Новый Массив;
	Для Каждого поле Из изменяемыеПоля Цикл
		Если скрываемыеПоля.Получить(поле.Имя) = Неопределено Тогда
			отображаемыеПоля.Добавить(поле);
		КонецЕсли;
	КонецЦикла;

	скрываемыеПоляМассив = Новый Массив;
	Для Каждого элемент Из скрываемыеПоля Цикл
		скрываемыеПоляМассив.Добавить(элемент.Значение);
	КонецЦикла;

	Возврат Новый Структура("СкрываемыеПоля, ОтображаемыеПоля, ТипПолучателя",
		скрываемыеПоляМассив, отображаемыеПоля, типПолучателя);
КонецФункции

#Область СлужебныеПоля
// Параметры:
//	плательщикСсылка - СправочникСсылка.Контрагенты
//
// Возвращаемое значение:
//	- Булево
&НаСервереБезКонтекста
Функция этоКлиент(Знач плательщикСсылка) // => Булево

	Если ТипЗнч(плательщикСсылка) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат Ложь;
	КонецЕсли;

	запросКонтрагента = Новый Запрос;
	запросКонтрагента.УстановитьПараметр("ПлательщикСсылка", плательщикСсылка);

	запросКонтрагента.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.ТипКонтрагента КАК ТипКонтрагента,
		|	Контрагенты.Ссылка КАК Контрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &ПлательщикСсылка
		|";

	выборка = запросКонтрагента.Выполнить().Выбрать();
	выборка.Следующий();

	Если ЗначениеЗаполнено(выборка.ТипКонтрагента)
		И выборка.ТипКонтрагента = Перечисления.ТипыКонтрагентов.Клиент Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция этоОплатаНаличными() // => Булево
	Возврат Объект.ТипДенежныхСредств = _ТипыДенежныхСредств.Наличные;
КонецФункции

&НаКлиенте
Функция этоОплатаБезналичными() // => Булево
	Возврат Объект.ТипДенежныхСредств = _ТипыДенежныхСредств.Безналичные;
КонецФункции

&НаКлиенте
Функция этоПрочееПоступление() // => Булево
	Возврат Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПрочееПоступление;
КонецФункции

&НаКлиенте
Функция этоВозвратОтПодотчетника() // => Булево
	Возврат Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника;
КонецФункции

&НаКлиенте
Функция этоПолучениеНаличныхВБанке() // => Булево
	Возврат Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке;
КонецФункции
#КонецОбласти // СлужебныеПоля

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийДиалоговФормы
// Функция обратного вызова.\
// Вызывается после закрытия диалогового окна с запросом подтверждения очистки неиспользуемых полей
// при изменении значения поля формы: ВидОперации
//
// Параметры:
//	кодВозврата - КодВозвратаДиалога
//	поляДляОчистки - Массив - Массив имен полей которые должны быть очищены
&НаКлиенте
Процедура _приЗапросеНаИзменениеВидаОперации_ОВ(Знач кодВозврата, поляДляОчистки) Экспорт
	Если кодВозврата = КодВозвратаДиалога.Да Тогда
		очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		_ВидОперацииБуфер = Объект.ВидОперации;
	Иначе
		Объект.ВидОперации = _ВидОперацииБуфер;
	КонецЕсли;
КонецПроцедуры

// Функция обратного вызова.\
// Вызывается после закрытия диалогового окна с запросом подтверждения очистки неиспользуемых полей
// при изменении значения поля формы: ВидОперации
//
// Параметры:
//	кодВозврата - КодВозвратаДиалога
//	поляДляОчистки - Массив - Массив имен полей которые должны быть очищены
&НаКлиенте
Процедура _приЗапросеНаИзменениеПлательщика_ОВ(Знач кодВозврата, поляДляОчистки) Экспорт
	Если кодВозврата = КодВозвратаДиалога.Да Тогда
		очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		_ПлательщикБуфер = Объект.Плательщик;
	Иначе
		Объект.Плательщик = _ПлательщикБуфер;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти // ФункцииОбратногоВызова

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область Инициализация

&НаКлиенте
Процедура инициализация()
	значенияПеречислений = получитьЗначенияПеречислений();
	_ТипыДенежныхСредств = значенияПеречислений.ТипыДенежныхСредств;
	_ВидыОперацийПоступленияДенег = значенияПеречислений.ВидыОперацийПоступленияДенег;

	_ПоляИзменяющиеТипФормы = Новый Структура;
	_ПоляИзменяющиеТипФормы.Вставить("ТипДенежныхСредств", "ТипДенежныхСредств");
	_ПоляИзменяющиеТипФормы.Вставить("ВидОперации", "ВидОперации");
	_ПоляИзменяющиеТипФормы.Вставить("Плательщик", "Плательщик");

	_НастраиваемыеПоляФормы = получитьНастраиваемыеПоляФормы();

	_ПлательщикБуфер = Объект.Плательщик;
	_ТипДенежныхСредствБуфер = Объект.ТипДенежныхСредств;
	_ВидОперацииБуфер = Объект.ВидОперации;
КонецПроцедуры

&НаСервере
Процедура инициализацияНаСервере()
	_ТипыДенежныхСредств = Документы.ПоступлениеДенежныхСредств.ПолучитьТипыДенежныхСредств();
	_ВидыОперацийПоступленияДенег = Документы.ПоступлениеДенежныхСредств.ПолучитьПолучитьВидыОперацийПоступленияДенег();
	Если Объект.Ссылка.Пустая() Тогда
		заполнитьПоляФормыЗначениямиПоУмолчаниюНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура заполнитьПоляФормыЗначениямиПоУмолчаниюНаСервере()
	Объект.ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Наличные;
	Объект.ВидОперации = Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя;
КонецПроцедуры

// Возвращаемое значение:
//	- Структура
&НаСервереБезКонтекста
Функция получитьЗначенияПеречислений()
	результат = Новый Структура;
	результат.Вставить("ТипыДенежныхСредств", Документы.ПоступлениеДенежныхСредств.ПолучитьТипыДенежныхСредств());
	результат.Вставить("ВидыОперацийПоступленияДенег", Документы.ПоступлениеДенежныхСредств.ПолучитьПолучитьВидыОперацийПоступленияДенег());

	Возврат результат;
КонецФункции

&НаКлиенте
Функция получитьНастраиваемыеПоляФормы()
	поляПоВидимости = Новый Массив;
	поляПоВидимости.Добавить(Элементы.ЭквайринговыйТерминал);
	поляПоВидимости.Добавить(Элементы.Касса);
	поляПоВидимости.Добавить(Элементы.ДоговорКонтрагента);
	поляПоВидимости.Добавить(Элементы.Плательщик);

	Возврат Новый ФиксированныйМассив(поляПоВидимости);
КонецФункции

#КонецОбласти // Инициализация
