﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ЭтотОбъект.ТекущаяРозничнаяЦена = РаботаСЦенамиВызовСервера.ПолучитьЦенуПродажиНаДату(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ИзменитьЦену(Команда)

	Если Объект.Ссылка.Пустая() Тогда
		сообщение_ = Новый СообщениеПользователю();
		сообщение_.Текст = "Перед установкой цены необходимо записать документ!";
		сообщение_.Сообщить();
	Иначе
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСозданияЦены",
			Новый Структура("Номенклатура", Объект.Ссылка), , , , ,
			Новый ОписаниеОповещения("_послеИзмененияЦены_ОВ", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	КонецЕсли;
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

&НаКлиенте
Процедура _послеИзмененияЦены_ОВ(_, __) Экспорт
	ЭтотОбъект.ТекущаяРозничнаяЦена = РаботаСЦенамиВызовСервера.ПолучитьЦенуПродажиНаДату(Объект.Ссылка);
КонецПроцедуры

#КонецОбласти // СлужебныйПрограммныйИнтерфейс
