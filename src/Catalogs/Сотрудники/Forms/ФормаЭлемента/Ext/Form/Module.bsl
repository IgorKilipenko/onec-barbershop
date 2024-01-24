﻿#Область ОпределениеПеременных

// Структура - Представление объекта: ФизическоеЛицо
&НаКлиенте
Перем _ФизическоеЛицо;

#КонецОбласти // ОпределениеПеременных

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(текущийОбъект)
	//_ФизическоеЛицо = получитьНаименованиеФизическогоЛица(текущийОбъект.ФизическоеЛицо.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(_)
	_ФизическоеЛицо = получитьПредставлениеФизическогоЛица(Объект.ФизическоеЛицо);
	заполнитьИнформационныеПоляФиоФормы();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(_)
	_ФизическоеЛицо = получитьПредставлениеФизическогоЛица(Объект.ФизическоеЛицо);
	Объект.Наименование = _ФизическоеЛицо.Наименование;
	заполнитьИнформационныеПоляФиоФормы();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция получитьПредставлениеФизическогоЛица(Знач физическойЛицоСсылка = Неопределено)
	Если физическойЛицоСсылка = Неопределено ИЛИ физическойЛицоСсылка.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;

	физЛицоПредставление = Новый Структура("Наименование, Фамилия, Имя, Отчество, Пол, ДатаРождения, КонтактныйТелефон");
	ЗаполнитьЗначенияСвойств(физЛицоПредставление, физическойЛицоСсылка);

	Возврат физЛицоПредставление;

	// Если физическойЛицоСсылка = Неопределено ИЛИ физическойЛицоСсылка.Пустая() Тогда
	// 	Возврат Неопределено;
	// КонецЕсли;
	//
	// запросФизическоеЛицо = Новый Запрос;
	// запросФизическоеЛицо.УстановитьПараметр("Ссылка", физическойЛицоСсылка);
	// запросФизическоеЛицо.Текст =
	// 	"ВЫБРАТЬ
	// 	|	*
	// 	|ИЗ
	// 	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	// 	|ГДЕ
	// 	|	ФизическиеЛица.Ссылка = &Ссылка
	// 	|";
	//
	// физЛицоПредставление = Новый Структура("Наименование, Фамилия, Имя, Отчество, Пол, ДатаРождения, КонтактныйТелефон");
	// выборка = запросФизическоеЛицо.Выполнить().Выборка();
	//
	// Если НЕ выборка.Следующий() Тогда
	// 	Возврат Неопределено;
	// КонецЕсли;
	//
	// ЗаполнитьЗначенияСвойств(физЛицоПредставление, физическойЛицоСсылка.ПолучитьОбъект());
	//
	// Возврат физЛицоПредставление;
КонецФункции

&НаКлиенте
Процедура заполнитьИнформационныеПоляФиоФормы()
	значениеФизическоеЛицоЗаполнено = ?(_ФизическоеЛицо = Неопределено, Ложь, Истина);

	ЭтаФорма.Фамилия = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.Фамилия, Неопределено);
	ЭтаФорма.Имя = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.Имя, Неопределено);
	ЭтаФорма.Отчество = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.Отчество, Неопределено);
	ЭтаФорма.Пол = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.Пол, Неопределено);
	ЭтаФорма.ДатаРождения = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.ДатаРождения, Неопределено);
	ЭтаФорма.КонтактныйТелефон = ?(значениеФизическоеЛицоЗаполнено, _ФизическоеЛицо.КонтактныйТелефон, Неопределено);
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
