﻿#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(_, __)
	Движения.ЦеныНоменклатурыПоставщиков.Записывать = Истина;
	Движения.ТоварыНаСкладах.Записывать = Истина;

	Для Каждого ТекСтрокаТовары Из Товары Цикл
		ВыполнитьДвижениеЦеныНоменклатурыПоставщиков(ТекСтрокаТовары);
		ВыполнитьДвижениеТоварыНаСкладах(ТекСтрокаТовары);
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(отказ, __, ___)
	Если ОбменДанными.Загрузка ИЛИ отказ Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(АвторДокумента) Тогда
		АвторДокумента = ?(ЗначениеЗаполнено(АвторДокумента), АвторДокумента, ПараметрыСеанса.ТекущийПользователь);
		СуммаДокумента = Товары.Итог("Сумма");
	КонецЕсли;
КонецПроцедуры
#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

#Область Движения
Процедура ВыполнитьДвижениеЦеныНоменклатурыПоставщиков(текСтрокаТовары)
	Движение = Движения.ЦеныНоменклатурыПоставщиков.Добавить();
	Движение.Период = Дата;
	Движение.Номенклатура = текСтрокаТовары.Номенклатура;
	Движение.Поставщик = Поставщик;
	Движение.Цена = текСтрокаТовары.Цена;
КонецПроцедуры

Процедура ВыполнитьДвижениеТоварыНаСкладах(текСтрокаТовары)
	Движение = Движения.ТоварыНаСкладах.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Номенклатура = текСтрокаТовары.Номенклатура;
	Движение.Склад = Склад;
	Движение.Количество = текСтрокаТовары.Количество;
КонецПроцедуры
#КонецОбласти // Движения

#КонецОбласти // СлужебныеПроцедурыИФункции
