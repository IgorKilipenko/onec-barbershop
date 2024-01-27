﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	заполнитьРеквизитыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(_)
	установитьВидимостьПолейФормы();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(_)
	показатьЗапросПользователюНаОчисткуПолейФормы("ТипДенежныхСредств");
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(_)
	показатьЗапросПользователюНаОчисткуПолейФормы("ВидОперации");
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура заполнитьРеквизитыФормы()
	этоНовыйОбъект = Объект.Ссылка.Пустая();

	ЭтотОбъект.Плательщик = Объект.Плательщик;
	ЭтотОбъект.ТипДенежныхСредств = ?(этоНовыйОбъект,
			Перечисления.ТипыДенежныхСредств.Наличные, Объект.ТипДенежныхСредств);
	ЭтотОбъект.ВидОперации = ?(этоНовыйОбъект,
			Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя, Объект.ВидОперации);
КонецПроцедуры

&НаКлиенте
Процедура установитьВидимостьПолейФормы()

	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		Элементы.Касса.Видимость = Истина;	//! Необходимо включить проверку заполнения
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		Элементы.Касса.Видимость = Ложь;
		Элементы.ЭквайринговыйТерминал.Видимость = Истина;	//! Необходимо включить проверку заполнения
	КонецЕсли;

	строкаТипПлательщика = получитьПредставлениеТипаПлательщика();

	Если строкаТипПлательщика = Неопределено Тогда
		Элементы.Плательщик.Видимость = Ложь;
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
		Элементы.Касса.Видимость = Истина;	//! Необходимо включить проверку заполнения
		Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
	Иначе
		этотПлательщикКонтрагент = НЕ (строкаТипПлательщика = "СправочникСсылка.Сотрудники" ИЛИ строкаТипПлательщика = "СправочникСсылка.Банки");
		Если этотПлательщикКонтрагент Тогда
			Элементы.ДоговорКонтрагента.Видимость = Истина;
			Элементы.Плательщик.Видимость = Истина;
		Иначе
			Элементы.ДоговорКонтрагента.Видимость = Ложь;
			Элементы.Плательщик.Видимость = Истина;	//! Необходимо включить проверку заполнения
			Элементы.Касса.Видимость = Истина;	//! Необходимо включить проверку заполнения
			Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
		КонецЕсли;

		списокДоступныхДляВыбораТипов = Новый Массив();
		списокДоступныхДляВыбораТипов.Добавить(Тип(строкаТипПлательщика));
		описаниеТипаПлательщика = Новый ОписаниеТипов(списокДоступныхДляВыбораТипов);
		Элементы.Плательщик.ОграничениеТипа = описаниеТипаПлательщика;
	КонецЕсли;

	Если Элементы.ДоговорКонтрагента.Видимость = Истина
		И ЗначениеЗаполнено(Объект.Плательщик) Тогда
		Элементы.ДоговорКонтрагента.Видимость = НЕ этоКлиент(Объект.Плательщик);
	КонецЕсли;

КонецПроцедуры

// Возвращаемое значение:
//	- Строка
//	- Неопределено
&НаКлиенте
Функция получитьПредставлениеТипаПлательщика() // => Строка | Неопределено
	строкаТипПлательщика = Неопределено;
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПрочееПоступление") Тогда
		Возврат строкаТипПлательщика;
	КонецЕсли;

	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника") Тогда
		строкаТипПлательщика = "СправочникСсылка.Сотрудники";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке") Тогда
		строкаТипПлательщика = "СправочникСсылка.Банки";
	Иначе
		строкаТипПлательщика = "СправочникСсылка.Контрагенты";
	КонецЕсли;

	Возврат строкаТипПлательщика;
КонецФункции

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
Процедура показатьЗапросПользователюНаОчисткуПолейФормы(имяРеквизита)
	Если имяРеквизита = "ТипДенежныхСредств" Тогда
		показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииТипаДенежныхСредств("_приЗапросеНаИзменениеТипаДенежныхСредств_ОВ");
	ИначеЕсли имяРеквизита = "ВидОперации" Тогда
		показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииВидаОперации("_приЗапросеНаИзменениеВидаОперации_ОВ");
	КонецЕсли;
КонецПроцедуры

// Открывает форму диалогового окна для подтверждения очистки ранее заполненных значений полей формы.\
// Вызывается при изменении значения поля формы: ТипаДенежныхСредств
//
// Параметры:
//	обратныйВызов - Строка - имя функции обратного вызова для обработки события: закрытие диалогового окна
//		по умолчанию - _приЗапросеНаИзменениеТипаДенежныхСредств_ОВ
&НаКлиенте
Процедура показатьЗапросПользователюНаОчисткуПолейФормы_ПриИзмененииТипаДенежныхСредств(обратныйВызов =
		"_приЗапросеНаИзменениеТипаДенежныхСредств_ОВ")
	имяРеквизита = "ТипДенежныхСредств";
	массивОчищаемыхРеквизитов = Новый Массив;
	текстЗапроса = СтрШаблон("При изменении реквизита ""%1"" будут очищены следующие данные:", имяРеквизита);

	текстЗапроса = текстЗапроса + "
		| - %1
		| Продолжить?";

	Если этоОплатаНаличными() И ЗначениеЗаполнено(Объект.ЭквайринговыйТерминал) Тогда
		массивОчищаемыхРеквизитов.Добавить("ЭквайринговыйТерминал");
		текстЗапроса = СтрШаблон(текстЗапроса, "Эквайринговый терминал");

	ИначеЕсли этоОплатаБезналичными() И ЗначениеЗаполнено(Объект.Касса) Тогда
		массивОчищаемыхРеквизитов.Добавить("Касса");
		текстЗапроса = СтрШаблон(текстЗапроса, "Касса");

	Иначе
		// Ошибка - Значение Перечисления {Перечисление.ТипыДенежныхСредств} Неопределено
		текстЗапроса = Неопределено;
	КонецЕсли;

	Если текстЗапроса <> Неопределено Тогда
		оповещение = Новый ОписаниеОповещения(обратныйВызов, ЭтотОбъект, массивОчищаемыхРеквизитов);
		ПоказатьВопрос(оповещение, текстЗапроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
	Иначе
		ЭтотОбъект.ТипДенежныхСредств = Объект.ТипДенежныхСредств;
		установитьВидимостьПолейФормы();
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
	текстЗапроса = Неопределено;

	значенияОчищаемыхПолейЗаполнены = ЗначениеЗаполнено(Объект.Плательщик) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента);

	Если (значенияОчищаемыхПолейЗаполнены И (этоВозвратОтПодотчетника() ИЛИ этоПолучениеНаличныхВБанке())) Тогда
		текстЗапроса = СтрШаблон("При изменении реквизита ""%1"" будут очищены следующие данные:", имяРеквизита);

		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			МассивОчищаемыхРеквизитов.Добавить("ДоговорКонтрагента");

			текстЗапроса = текстЗапроса + "
				| - %1";
			текстЗапроса = СтрШаблон(текстЗапроса, "Договор");
		КонецЕсли;

		Если этоПрочееПоступление() И ЗначениеЗаполнено(Объект.Плательщик) Тогда
			МассивОчищаемыхРеквизитов.Добавить("Плательщик");

			текстЗапроса = текстЗапроса + "
				| - %1";
			текстЗапроса = СтрШаблон(текстЗапроса, "Плательщик");
		КонецЕсли;

		Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
			текстЗапроса = текстЗапроса + "
				| Продолжить?";
		Иначе
			текстЗапроса = Неопределено;
		КонецЕсли;
	КонецЕсли;

	Если текстЗапроса <> Неопределено Тогда
		оповещение = Новый ОписаниеОповещения(обратныйВызов, ЭтотОбъект, МассивОчищаемыхРеквизитов);
		ПоказатьВопрос(оповещение, текстЗапроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
	Иначе
		// Поля для очистки не заполнены или ВидОперации не входит в диапазон значений: [ВозвратОтПодотчетника, ПолучениеНаличныхВБанке].
		ЭтотОбъект.ВидОперации = Объект.ВидОперации;
		установитьВидимостьПолейФормы();
		Возврат; // Оповещение пользователю не показываем
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
	установитьВидимостьПолейФормы();
КонецПроцедуры

#Область СлужебныеПоля
&НаКлиенте
Функция этоОплатаНаличными() // => Булево
	Возврат Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные");
КонецФункции

&НаКлиенте
Функция этоОплатаБезналичными() // => Булево
	Возврат Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные");
КонецФункции

&НаКлиенте
Функция этоПрочееПоступление() // => Булево
	Возврат Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПрочееПоступление");
КонецФункции

&НаКлиенте
Функция этоВозвратОтПодотчетника() // => Булево
	Возврат Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника");
КонецФункции

&НаКлиенте
Функция этоПолучениеНаличныхВБанке() // => Булево
	Возврат Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке");
КонецФункции
#КонецОбласти // СлужебныеПоля

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийДиалоговФормы
// Функция обратного вызова.\
// Вызывается после закрытия диалогового окна с запросом подтверждения очистки неиспользуемых полей
// при изменении значения поля формы: ТипДенежныхСредств
//
// Параметры:
//	кодВозврата - КодВозвратаДиалога
//	поляДляОчистки - Массив - Массив имен полей которые должны быть очищены
&НаКлиенте
Процедура _приЗапросеНаИзменениеТипаДенежныхСредств_ОВ(Знач кодВозврата, поляДляОчистки) Экспорт
	Если кодВозврата = КодВозвратаДиалога.Да Тогда
		очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		ЭтотОбъект.ТипДенежныхСредств = Объект.ТипДенежныхСредств;
	Иначе
		Объект.ТипДенежныхСредств = ЭтотОбъект.ТипДенежныхСредств;
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
Процедура _приЗапросеНаИзменениеВидаОперации_ОВ(Знач кодВозврата, поляДляОчистки) Экспорт
	Если кодВозврата = КодВозвратаДиалога.Да Тогда
		очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		установитьВидимостьПолейФормы();
		ЭтотОбъект.Плательщик = Объект.Плательщик;
	Иначе
		Объект.Плательщик = ЭтотОбъект.Плательщик;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти // ФункцииОбратногоВызова

#КонецОбласти // СлужебныйПрограммныйИнтерфейс
