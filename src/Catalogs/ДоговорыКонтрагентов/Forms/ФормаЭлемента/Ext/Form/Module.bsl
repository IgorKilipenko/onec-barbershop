﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(_)
	установитьВидимостьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(_, __)
	установитьНаименованияДоговора();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПризнакБессрочногоДоговораПриИзменении(_)
	установитьВидимостьЭлементовФормы();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура установитьВидимостьЭлементовФормы()
	Элементы.ДатаОкончанияДоговора.Видимость = НЕ этоБессрочныйДоговор();
	Если НЕ Элементы.ДатаОкончанияДоговора.Видимость Тогда
		Объект.ДатаОкончанияДоговора = '0001,01,01';
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура установитьНаименованияДоговора()
	Объект.Наименование = сформироватьСтрокуНаименованияДоговора(Объект.ВнешнийНомерДоговора,
			Объект.ДатаЗаключенияДоговора);
КонецПроцедуры

&НаКлиенте
Функция сформироватьСтрокуНаименованияДоговора(номерДоговора, датаЗаключения)
	Возврат СтрШаблон("№%1 от %2 г.", номерДоговора, Формат(датаЗаключения, "Л=ru_RU; ДФ=дд.MMМM.гггг"));
КонецФункции

&НаКлиенте
Функция этоБессрочныйДоговор()
	Возврат Объект.ПризнакБессрочногоДоговора;
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
