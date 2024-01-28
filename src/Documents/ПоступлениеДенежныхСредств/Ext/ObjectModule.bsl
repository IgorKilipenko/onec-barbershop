﻿#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(_, __, ___)
	РаботаСДокументами.ЗаполнитьПолеАвторДокументаНаСервере(ЭтотОбъект);
КонецПроцедуры

Процедура ОбработкаПроведения(_, __)
	Если ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Наличные Тогда
		Движения.ДенежныеСредства.Записывать = Истина;
		выполнитьДвижениеДенежныеСредстваПриход();
	ИначеЕсли ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Безналичные Тогда
		Движения.БезналичнаяОплата.Записывать = Истина;
		выполнитьДвижениеБезналичнаяОплатаОборот();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

#Область Движения
Процедура выполнитьДвижениеДенежныеСредстваПриход()
	движение = Движения.ДенежныеСредства.Добавить();
	движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	движение.Период = Дата;
	движение.БанковскийСчетКасса = Касса;
	движение.ТипДенежныхСредств = ТипДенежныхСредств;
	движение.Сумма = СуммаДокумента;
КонецПроцедуры

Процедура выполнитьДвижениеБезналичнаяОплатаОборот()
	движение = Движения.БезналичнаяОплата.Добавить();
	движение.Период = Дата;
	движение.ЭквайринговыйТерминал = ЭквайринговыйТерминал;
	движение.Сумма = СуммаДокумента;
КонецПроцедуры
#КонецОбласти // Движения

#КонецОбласти // СлужебныеПроцедурыИФункции
