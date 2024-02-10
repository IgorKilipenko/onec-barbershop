﻿#Область ПрограммныйИнтерфейс

Функция РассчитатьДатуОкончанияЗаписи() Экспорт
	услугиТЗ = Услуги.Выгрузить( , "Номенклатура");
	Возврат ДатаЗаписи + Документы.ЗаписьКлиента.РассчитатьДлительностьОказанияУслуг(услугиТЗ) * 60;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(_, __, ___)
	РаботаСДокументами.ЗаполнитьПолеАвторДокументаНаСервере(ЭтотОбъект);
КонецПроцедуры

Процедура ОбработкаПроведения(_, __)
	Движения.ЗаказыКлиентов.Записывать = Истина;
	Для Каждого текСтрокаУслуги Из Услуги Цикл
		выполнитьДвижениеЗаказыКлиентовПриход(текСтрокаУслуги);
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(_, __, ___)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	УслугаОказана = ЗначениеЗаполнено(Документы.ЗаписьКлиента.ПолучитьДокументРеализацииНаОсновании(Ссылка));
	ДатаОкончанияЗаписи = РассчитатьДатуОкончанияЗаписи();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

Функция создатьДвижениеЗаказыКлиентовПриход()
	движение = Движения.ЗаказыКлиентов.Добавить();
	движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	движение.Период = Дата;
	движение.Клиент = Клиент;
	движение.ДатаЗаписи = ДатаЗаписи;

	Возврат движение;
КонецФункции

// Параметры:
//	услуга - ДокументТабличнаяЧастьСтрока.ЗаписьКлиента.Услуги
Процедура выполнитьДвижениеЗаказыКлиентовПриход(услуга)
	движение = создатьДвижениеЗаказыКлиентовПриход();
	движение.Номенклатура = услуга.Номенклатура;
	движение.Количество = услуга.Количество;
	движение.Сумма = услуга.Сумма;
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
