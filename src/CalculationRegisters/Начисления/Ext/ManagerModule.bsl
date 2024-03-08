﻿#Область ПрограммныйИнтерфейс

Функция ЗаполнитьДвижениеНачисления(Знач движение, Знач периодНачисления, Знач структураНачисления) Экспорт
	движение.Сторно = Ложь;
	
    движение.ПериодРегистрации = периодНачисления;
	движение.ПериодДействияНачало = структураНачисления.ДатаНачала;
	движение.ПериодДействияКонец = структураНачисления.ДатаОкончания;
	движение.БазовыйПериодНачало = структураНачисления.ДатаНачала;
	движение.БазовыйПериодКонец = структураНачисления.ДатаОкончания;
	движение.Сотрудник = структураНачисления.Сотрудник;
	движение.ПоказательРасчета = структураНачисления.ПоказательРасчета;
	движение.График = структураНачисления.ГрафикРаботы;
    движение.Сумма = 0;
	
	Возврат движение;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
