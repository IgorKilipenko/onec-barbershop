﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Объект.УслугаОказана = ЗначениеЗаполнено(Документы.ЗаписьКлиента.ПолучитьДокументРеализацииНаОсновании(Объект.Ссылка));
	Иначе
		Если Параметры.Свойство("Начало") Тогда
			Объект.ДатаЗаписи = Параметры.Начало;
		КонецЕсли;

		Если Параметры.Свойство("Окончание") Тогда
			Объект.ДатаОкончанияЗаписи = Параметры.Окончание;
		КонецЕсли;

		Если Параметры.Свойство("Сотрудник") Тогда
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
	КонецЕсли;

	установитьДоступностьЭлементовФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(_)
	Оповестить("Записан заказ");
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура УслугиУслугаПриИзменении(_)
	текущаяСтрокаУслуги = Элементы.Услуги.ТекущиеДанные;
	текущаяСтрокаУслуги.Цена = получитьЦенуПродажи(текущаяСтрокаУслуги.Номенклатура);
	обновитьСуммуПоСтрокеУслуг();
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(_)
	обновитьСуммуПоСтрокеУслуг();
КонецПроцедуры

&НаКлиенте
Процедура УслугиПослеУдаления(_)
	обновитьСуммуПоСтрокеУслуг();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовТаблицыФормыУслуги

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура обновитьСуммуПоСтрокеУслуг()
	текущаяСтрокаУслуги = Элементы.Услуги.ТекущиеДанные;
	текущаяСтрокаУслуги.Сумма = текущаяСтрокаУслуги.Количество * текущаяСтрокаУслуги.Цена;
КонецПроцедуры

&НаКлиенте
Функция получитьЦенуПродажи(Знач номенклатура)
	цена = РаботаСЦенамиВызовСервера.ПолучитьЦенуПродажиНаДату(номенклатура);

	Если цена = Неопределено Тогда
		текстСообщения = СтрШаблон("Не удалось получить текущую цену продажи для номенклатуры: ""%1"".
				|Проверьте наличие цены для номенклатуры в регистре цен",
				номенклатура);
		ПоказатьПредупреждение( , текстСообщения);
		цена = 0;
	КонецЕсли;

	Возврат цена;
КонецФункции

&НаСервере
Процедура установитьДоступностьЭлементовФормыНаСервере()
	Элементы.УслугаОказана.ТолькоПросмотр = НЕ (РольДоступна("ПолныеПрава") ИЛИ ПривилегированныйРежим());
	Элементы.Дата.ТолькоПросмотр = 
		НЕ (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Руководитель") ИЛИ ПривилегированныйРежим());
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
