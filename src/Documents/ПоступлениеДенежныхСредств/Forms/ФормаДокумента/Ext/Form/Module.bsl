﻿#Область ОписаниеПеременных

&НаКлиенте
Перем _ТипыДенежныхСредств;

&НаКлиенте
Перем _ВидыОперацийПоступленияДенег;

&НаКлиенте
Перем _Состояние;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	инициализацияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(_)
	инициализация();

	поляИзменяющиеТипФормы = Новый Массив;
	поляИзменяющиеТипФормы.Добавить(Элементы.Плательщик);
	поляИзменяющиеТипФормы.Добавить(Элементы.ТипДенежныхСредств);
	поляИзменяющиеТипФормы.Добавить(Элементы.ВидОперации);

	Для Каждого поле Из поляИзменяющиеТипФормы Цикл
		применитьНастройкиПолейФормы(Новый Структура("УправляющееПоле", поле));
	КонецЦикла;

КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(_)
	изменитьТипФормы(Элементы.ТипДенежныхСредств);
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(_)
	изменитьТипФормы(Элементы.ВидОперации);
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(_)
	изменитьТипФормы(Элементы.Плательщик);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура применитьНастройкиПолейФормы(настройкиПолей)
	Если настройкиПолей = Неопределено ИЛИ ТипЗнч(настройкиПолей) <> Тип("Структура") Тогда
		Возврат; // Ошибка
	КонецЕсли;

	Если (НЕ настройкиПолей.Свойство("ЗначенияУстановлены")) И настройкиПолей.Свойство("УправляющееПоле") Тогда
		настройкиПолей = получитьНастройкиОтображенияПолей(настройкиПолей.УправляющееПоле);
	КонецЕсли;

	Для Каждого поле Из настройкиПолей.СкрываемыеПоля Цикл
		поле.Видимость = Ложь;
	КонецЦикла;

	Для Каждого поле Из настройкиПолей.ОтображаемыеПоля Цикл
		поле.Видимость = Истина;
	КонецЦикла;

	Если настройкиПолей.ТипПлательщика <> Неопределено И Элементы.Плательщик.Видимость Тогда
		массивОграничений = Новый Массив;
		массивОграничений.Добавить(настройкиПолей.ТипПлательщика);
		описаниеТипаПлательщика = Новый ОписаниеТипов(массивОграничений);
		Элементы.Плательщик.ОграничениеТипа = описаниеТипаПлательщика;

		Если настройкиПолей.ТипПлательщика = Тип("СправочникСсылка.Контрагенты") Тогда
			типКонтрагента = ?(Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПоставщика,
					ПредопределенноеЗначение("Перечисление.ТипыКонтрагентов.Поставщик"),
					ПредопределенноеЗначение("Перечисление.ТипыКонтрагентов.Клиент"));

			параметрыВыбораПлательщика = Новый Массив;
			параметрыВыбораПлательщика.Добавить(Новый ПараметрВыбора("Отбор.ТипКонтрагента", типКонтрагента));

			Элементы.Плательщик.ПараметрыВыбора = Новый ФиксированныйМассив(параметрыВыбораПлательщика);
		КонецЕсли;

	ИначеЕсли НЕ Элементы.Плательщик.Видимость Тогда
		Элементы.Плательщик.ОграничениеТипа = Новый ОписаниеТипов(Новый Массив);

	КонецЕсли;

	_Состояние[настройкиПолей.УправляющееПоле.Имя] = Объект[настройкиПолей.УправляющееПоле.Имя];
КонецПроцедуры

// Возвращаемое значение:
//	- Строка, Неопределено
&НаКлиенте
Функция получитьТипПлательщика() // => Строка | Неопределено
	Если Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПрочееПоступление Тогда
		Возврат Неопределено;
	КонецЕсли;

	типПлательщика = Неопределено;
	Если Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника Тогда
		типПлательщика = Тип("СправочникСсылка.Сотрудники");

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке Тогда
		типПлательщика = Тип("СправочникСсылка.Банки");

	Иначе
		типПлательщика = Тип("СправочникСсылка.Контрагенты");

	КонецЕсли;

	Возврат типПлательщика;
КонецФункции

&НаКлиенте
Асинх Процедура изменитьТипФормы(Знач управляющееПоле)
	имяУправляющегоРеквизита = управляющееПоле.Имя;

	Если НЕ проверитьПолеСостоянияФормыПоРеквизиту(имяУправляющегоРеквизита) Тогда
		// Ошибка! Имя реквизита-источника события не входит в список полей изменяющих тип отображения формы
		Возврат;
	КонецЕсли;

	поляДляОчистки = Новый Массив;

	параметрыОтображенияПолей = получитьНастройкиОтображенияПолей(Элементы[имяУправляющегоРеквизита]);
	Для Каждого поле Из параметрыОтображенияПолей.СкрываемыеПоля Цикл
		Если ЗначениеЗаполнено(поле.ТекстРедактирования) Тогда
			поляДляОчистки.Добавить(поле.Имя);
		КонецЕсли;
	КонецЦикла;

	текстВопроса = сформироватьТекстЗапросаОчисткиПолей(имяУправляющегоРеквизита, поляДляОчистки);
	применитьИзменения = Истина;

	Если поляДляОчистки.Количество() > 0 И ЗначениеЗаполнено(текстВопроса) Тогда
		кодВозврата = Ждать ВопросАсинх(текстВопроса, РежимДиалогаВопрос.ДаНет, , , "Внимание!");
		отменитьИзменение = кодВозврата <> КодВозвратаДиалога.Да;

		Если отменитьИзменение Тогда
			Объект[имяУправляющегоРеквизита] = _Состояние[имяУправляющегоРеквизита]; // Возврат значений полей (отмена очистки)
			применитьИзменения = Ложь;
		Иначе
			очиститьНеиспользуемыеРеквизитыФормы(поляДляОчистки);
		КонецЕсли;
	КонецЕсли;

	Если применитьИзменения Тогда
		применитьНастройкиПолейФормы(параметрыОтображенияПолей);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция сформироватьТекстЗапросаОчисткиПолей(Знач имяУправляющегоРеквизита, поляДляОчистки) // => Строка | Неопределено
	Если поляДляОчистки = Неопределено ИЛИ поляДляОчистки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	текстВопроса_ = СтрШаблон("При изменении реквизита ""%1"" будут очищены следующие данные:", имяУправляющегоРеквизита);

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

// Параметры:
//	имяРеквизита - Строка
//
// Возвращаемое значение:
//	Булево - Истина если проверка успешна
&НаКлиенте
Функция проверитьПолеСостоянияФормыПоРеквизиту(Знач имяРеквизита)
	Если имяРеквизита = Элементы.ТипДенежныхСредств.Имя
		ИЛИ имяРеквизита = Элементы.ВидОперации.Имя
		ИЛИ имяРеквизита = Элементы.Плательщик.Имя Тогда

		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

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

// Параметры:
//	управляющееПоле - ЭлементФормы - ВидОперации, ТипДенежныхСредств, Плательщик
//	типОплаты - ПеречислениеСсылка.ТипыДенежныхСредств, Неопределено
//	видОперации - ПеречислениеСсылка.ВидыОперацийПоступленияДенег, Неопределено
//	плательщик - СправочникСсылка.Контрагент, СправочникСсылка.Сотрудники, СправочникСсылка.Банки, Неопределено
//
// Возвращаемое значение:
//	- Структура
&НаКлиенте
Функция получитьНастройкиОтображенияПолей(управляющееПоле, типОплаты = Неопределено,
		видОперации = Неопределено, плательщик = Неопределено)

	Если управляющееПоле = Элементы.ТипДенежныхСредств Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииТипаОплаты(типОплаты);

	ИначеЕсли управляющееПоле = Элементы.ВидОперации Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииВидаОперации(видОперации);

	ИначеЕсли управляющееПоле = Элементы.Плательщик Тогда
		Возврат получитьСкрываемыеПоляПриИзмененииПлательщика(плательщик);
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииТипаОплаты(типОплаты = Неопределено)
	скрываемыеПоля = Новый Структура;
	изменяемыеПоля = Новый Массив;

	изменяемыеПоля.Добавить(Элементы.Касса);
	изменяемыеПоля.Добавить(Элементы.ЭквайринговыйТерминал);

	типОплаты = ?(типОплаты = Неопределено, Объект.ТипДенежныхСредств, типОплаты);
	Если типОплаты = _ТипыДенежныхСредств.Наличные Тогда
		скрываемыеПоля.Вставить(Элементы.ЭквайринговыйТерминал.Имя, Элементы.ЭквайринговыйТерминал);

	ИначеЕсли типОплаты = _ТипыДенежныхСредств.Безналичные Тогда
		скрываемыеПоля.Вставить(Элементы.Касса.Имя, Элементы.Касса);
	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(Элементы.ТипДенежныхСредств, скрываемыеПоля, изменяемыеПоля);
КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииВидаОперации(видОперации = Неопределено)
	скрываемыеПоля = Новый Структура;
	изменяемыеПоля = Новый Массив;
	типПлательщика = Неопределено;

	изменяемыеПоля.Добавить(Элементы.ДоговорКонтрагента);
	изменяемыеПоля.Добавить(Элементы.Плательщик);

	видОперации = ?(видОперации = Неопределено, Объект.ВидОперации, видОперации);

	Если видОперации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Если видОперации = _ВидыОперацийПоступленияДенег.ПрочееПоступление Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		скрываемыеПоля.Вставить(Элементы.Плательщик.Имя, Элементы.Плательщик);

	ИначеЕсли видОперации = _ВидыОперацийПоступленияДенег.ОплатаОтПокупателя Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПлательщика = Тип("СправочникСсылка.Контрагенты");
	ИначеЕсли видОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПоставщика Тогда
		типПлательщика = Тип("СправочникСсылка.Контрагенты");

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПлательщика = Тип("СправочникСсылка.Сотрудники");

	ИначеЕсли Объект.ВидОперации = _ВидыОперацийПоступленияДенег.ПолучениеНаличныхВБанке Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
		типПлательщика = Тип("СправочникСсылка.Банки");

	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(Элементы.ВидОперации, скрываемыеПоля, изменяемыеПоля, типПлательщика);
КонецФункции

&НаКлиенте
Функция получитьСкрываемыеПоляПриИзмененииПлательщика(плательщик = Неопределено)
	скрываемыеПоля = Новый Структура;
	изменяемыеПоля = Новый Массив;

	изменяемыеПоля.Добавить(Элементы.ДоговорКонтрагента);

	плательщик = ?(плательщик = Неопределено, Объект.Плательщик, плательщик);
	Если ЗначениеЗаполнено(плательщик) И (НЕ этотКонтрагентПоставщик(плательщик)) Тогда
		скрываемыеПоля.Вставить(Элементы.ДоговорКонтрагента.Имя, Элементы.ДоговорКонтрагента);
	КонецЕсли;

	Возврат создатьОбъектПараметровНастраиваемогоПоля(Элементы.Плательщик, скрываемыеПоля, изменяемыеПоля);
КонецФункции

&НаКлиенте
Функция создатьОбъектПараметровНастраиваемогоПоля(управляющееПоле, скрываемыеПоля, изменяемыеПоля, типПлательщика = Неопределено)
	отображаемыеПоля = Новый Массив;
	Для Каждого поле Из изменяемыеПоля Цикл
		Если НЕ (скрываемыеПоля.Свойство(поле.Имя) ИЛИ поле.Видимость) Тогда
			отображаемыеПоля.Добавить(поле);
		КонецЕсли;
	КонецЦикла;

	скрываемыеПоляМассив = Новый Массив;
	Для Каждого элемент Из скрываемыеПоля Цикл
		Если элемент.Значение.Видимость Тогда
			скрываемыеПоляМассив.Добавить(элемент.Значение);
		КонецЕсли;
	КонецЦикла;

	результат = Новый Структура;
	результат.Вставить("ОтображаемыеПоля", отображаемыеПоля);
	результат.Вставить("УправляющееПоле", управляющееПоле);
	результат.Вставить("СкрываемыеПоля", скрываемыеПоляМассив);
	результат.Вставить("ТипПлательщика", типПлательщика);
	результат.Вставить("ЗначенияУстановлены", Истина);

	Возврат результат;
КонецФункции

&НаСервереБезКонтекста
Функция получитьТипКонтрагентаНаСервере(Знач плательщикСсылка = Неопределено)
	Если (НЕ ЗначениеЗаполнено(плательщикСсылка))
		ИЛИ ТипЗнч(плательщикСсылка) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат Неопределено;
	КонецЕсли;

	запросКонтрагента = Новый Запрос;
	запросКонтрагента.УстановитьПараметр("Ссылка", плательщикСсылка);

	запросКонтрагента.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.ТипКонтрагента КАК ТипКонтрагента
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка
		|";

	выборка = запросКонтрагента.Выполнить().Выбрать();
	Если выборка.Следующий() Тогда
		Возврат выборка.ТипКонтрагента;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

#Область СлужебныеПоля
// Параметры:
//	плательщикСсылка - СправочникСсылка.Контрагенты
//
// Возвращаемое значение:
//	- Булево
&НаКлиенте
Функция этотКонтрагентКлиент(Знач плательщикСсылка) // => Булево
	Возврат получитьТипКонтрагентаНаСервере(плательщикСсылка) = ПредопределенноеЗначение("Перечисление.ТипыКонтрагентов.Клиент");
КонецФункции

&НаКлиенте
Функция этотКонтрагентПоставщик(Знач плательщикСсылка)
	Возврат получитьТипКонтрагентаНаСервере(плательщикСсылка) = ПредопределенноеЗначение("Перечисление.ТипыКонтрагентов.Поставщик");
КонецФункции

&НаКлиенте
Функция этоБанк(Знач плательщикСсылка)
	Возврат ТипЗнч(плательщикСсылка) = Тип("СправочникСсылка.Банки");
КонецФункции

&НаКлиенте
Функция этоСотрудник(Знач плательщикСсылка)
	Возврат ТипЗнч(плательщикСсылка) = Тип("СправочникСсылка.Сотрудники");
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

#Область Инициализация

&НаКлиенте
Процедура инициализация()
	значенияПеречислений = получитьЗначенияПеречислений();
	_ТипыДенежныхСредств = значенияПеречислений.ТипыДенежныхСредств;
	_ВидыОперацийПоступленияДенег = значенияПеречислений.ВидыОперацийПоступленияДенег;

	_Состояние = Новый Структура("ВидОперации, Плательщик, ТипДенежныхСредств");
	_Состояние.ВидОперации = Объект.ВидОперации;
	_Состояние.Плательщик = Объект.Плательщик;
	_Состояние.ТипДенежныхСредств = Объект.ТипДенежныхСредств;
КонецПроцедуры

&НаСервере
Процедура инициализацияНаСервере()
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
