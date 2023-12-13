﻿#Область ОписаниеПеременных

// Хранит кэш значения Перечисления.ТипыКонтрагентов (Только для чтения)
Перем __КэшТипыКонтрагентов__;

// Хранит кэш массива ссылок на поля формы доступные только при ТипеКонтрагента == Клиент (Только для чтения). \
// Для доступа к полю использовать функцию: получитьПоляТолькоДляКлиента()
Перем __ПоляТолькоДляКлиента__;

// Хранит кэш массива ссылок на поля формы доступные только при ТипеКонтрагента == Поставщик (Только для чтения). \
// Для доступа к полю использовать функцию: получитьПоляТолькоДляПоставщика()
Перем __ПоляТолькоДляПоставщика__;

#КонецОбласти // ОписаниеПеременных

#Область ОбработчикиСобытийФормы

// Обработчик события формы ПриОткрытии (НаКлиенте)
// Параметры:
// _ - ЭлементФормы - не используется в текущей реализации
&НаКлиенте
Процедура ПриОткрытии(_)
	настройкаВидаФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(отказ, параметрыЗаписи)
	Если этоКлиент() Тогда
		Если Объект.ФизическоеЛицо.Пустая() Тогда // Ошибка! не заполнено обязательное поле для Клиента: ФизическоеЛицо
			отказ = Истина;
			Возврат;
		КонецЕсли;

		Объект.Наименование = ?(ЗначениеЗаполнено(Объект.Наименование), Объект.Наименование, получитьФиоФизическогоЛица());
		ОчиститьПоляДляКлиента();

		Возврат;
	КонецЕсли;

	Если этоПоставщик() Тогда
		ОчиститьПоляДляПоставщика();
	КонецЕсли;

КонецПроцедуры


#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события поля формы ПриИзменении / для поля ТипКонтрагента (НаКлиенте)
// Параметры:
// _ - ЭлементФормы - не используется в текущей реализации
&НаКлиенте
Процедура ТипКонтрагентаПриИзменении(_)
	настройкаВидаФормы();
КонецПроцедуры

// Обработчик события формы ПриОткрытии (НаКлиенте)
// Параметры:
// _ - ЭлементФормы - не используется в текущей реализации
&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(_)
	заполнитьКонтактныйТелефонКлиента();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

// Выполняет настройку полей формы в соответствии
// с выбранным значением Типа Контрагента / Клиент или Поставщик (НаКлиенте)
&НаКлиенте
Процедура настройкаВидаФормы()
	этоКлиент_ = этоКлиент();
	настроитьВидФормыДляКлиента(этоКлиент_);

	этоПоставщик_ = ?(этоКлиент_, Ложь, этоПоставщик());
	настроитьВидФормыДляПоставщика(этоПоставщик_);
КонецПроцедуры

// Параметры:
// 	этоКлиент - Булево
&НаКлиенте
Процедура настроитьВидФормыДляКлиента(этоКлиент)
	Для Каждого полеФормы Из получитьПоляФормыТолькоДляКлиента() Цикл
		полеФормы.Видимость = этоКлиент;
	КонецЦикла;

	Если этоКлиент Тогда
		заполнитьКонтактныйТелефонКлиента();
	КонецЕсли;
КонецПроцедуры

// Параметры:
// 	этоПоставщик - Булево
&НаКлиенте
Процедура настроитьВидФормыДляПоставщика(этоПоставщик)
	Для Каждого полеФормы Из получитьПоляФормыТолькоДляПоставщика() Цикл
		полеФормы.Видимость = этоПоставщик;
	КонецЦикла;

	Элементы.Наименование.Заголовок = ?(этоПоставщик, стрПредставлениеПоставщик(), Элементы.Наименование.Заголовок);
КонецПроцедуры

// Функция этоКлиент (НаКлиенте)
// Возвращаемое значение:
// 	Булево - Истина, если текущий элемент это Клиент
&НаКлиенте
Функция этоКлиент()
	Возврат Объект.ТипКонтрагента = получитьЗначениеТипаКонтрагента(стрПредставлениеКлиент());
КонецФункции

// Функция этоПоставщик (НаКлиенте)
// Возвращаемое значение:
// 	Булево - Истина, если текущий элемент это Поставщик
&НаКлиенте
Функция этоПоставщик()
	Возврат Объект.ТипКонтрагента = получитьЗначениеТипаКонтрагента(стрПредставлениеПоставщик());
КонецФункции

// Получить значение типа контрагента (НаСервере)
// Параметры:
//	имяТипаКонтрагента - Строка - строковое значение из Перечисления.ТипыКонтрагентов
// Возвращаемое значение:
// 	Перечисления.ТипыКонтрагентов.ТипКонтрагента
&НаСервере
Функция получитьЗначениеТипаКонтрагента(Знач имяТипаКонтрагента)
	Возврат получитьТипыКонтрагентов()[имяТипаКонтрагента];
КонецФункции

// Получить типы контрагентов (НаСервере)
// Возвращаемое значение:
// 	Перечисления.ТипыКонтрагентов
&НаСервере
Функция получитьТипыКонтрагентов()
	__КэшТипыКонтрагентов__ = ?(__КэшТипыКонтрагентов__ <> Неопределено,
			__КэшТипыКонтрагентов__, Справочники.Контрагенты.ПолучитьТипыКонтрагентов());
	Возврат __КэшТипыКонтрагентов__;
КонецФункции

#Область ПриватныеКонстанты

// Используется как КОНСТАНТА для минимизации использования строковых литералов
// Возвращаемое значение:
// 	Строка - значение имени реквизита Поставщик
&НаКлиенте
Функция стрПредставлениеПоставщик()
	Возврат "Поставщик";
КонецФункции

// Используется как КОНСТАНТА для минимизации использования строковых литералов
// Возвращаемое значение:
// 	Строка - значение имени реквизита Поставщик
&НаКлиенте
Функция стрПредставлениеКлиент()
	Возврат "Клиент";
КонецФункции
#КонецОбласти

&НаКлиенте
Процедура заполнитьКонтактныйТелефонКлиента()
	контактныйТелефон = получитьКонтактныйТелефонФизическогоЛица();
	Объект.КонтактныйТелефон = ?(НЕ ЗначениеЗаполнено(контактныйТелефон),
			Объект.КонтактныйТелефон, контактныйТелефон);
КонецПроцедуры

// Получает контактный телефон заполненный для физического лица (НаСервере). \
// [Комментарий разработчика] - Думаю вызова функции на стороне сервера можно избежать)!
// Возвращаемое значение:
// 	Строка - контактный телефон физического лица
&НаСервере
Функция получитьКонтактныйТелефонФизическогоЛица()
	Возврат ?(Объект.ФизическоеЛицо.Пустая(),
		"", Объект.ФизическоеЛицо.КонтактныйТелефон);
КонецФункции

// Возвращаемое значение:
// 	Строка - Ф.И.О. физического лица
&НаСервере
Функция получитьФиоФизическогоЛица()
	Возврат ?(Объект.ФизическоеЛицо.Пустая(),
		"", Объект.ФизическоеЛицо.Наименование);
КонецФункции

&НаКлиенте
Процедура ОчиститьПоляДляПоставщика()
	Объект.ФизическоеЛицо = NULL;
	Объект.Источник = NULL;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоляДляКлиента()
	Объект.ОсновнойДоговор = NULL;
КонецПроцедуры

// Возвращаемое значение:
// 	Массив - массив полей формы доступных только для Клиента
&НаКлиенте
Функция получитьПоляФормыТолькоДляКлиента()
	// [Можно лучше!] В перспективе в конструкторе формы лучше создать группу
	// для группировки специальных полей типа контрагента
	__ПоляТолькоДляКлиента__ = ?(__ПоляТолькоДляКлиента__ <> Неопределено,
			__ПоляТолькоДляКлиента__, Новый Массив);

	Если __ПоляТолькоДляКлиента__.Количество() = 0 Тогда
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицо);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицоФамилия);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицоИмя);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицоОтчество);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицоПол);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.ФизическоеЛицоДатаРождения);
		__ПоляТолькоДляКлиента__.Добавить(Элементы.Источник);
	КонецЕсли;

	Возврат __ПоляТолькоДляКлиента__;
КонецФункции

// Возвращаемое значение:
// 	Массив - массив полей формы доступных только для Поставщика
&НаКлиенте
Функция получитьПоляФормыТолькоДляПоставщика()
	__ПоляТолькоДляПоставщика__ = ?(__ПоляТолькоДляПоставщика__ <> Неопределено,
			__ПоляТолькоДляПоставщика__, Новый Массив);
	Если __ПоляТолькоДляПоставщика__.Количество() = 0 Тогда
		__ПоляТолькоДляПоставщика__.Добавить(Элементы.Наименование);
		__ПоляТолькоДляПоставщика__.Добавить(Элементы.ОсновнойДоговор);
	КонецЕсли;

	Возврат __ПоляТолькоДляПоставщика__;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
