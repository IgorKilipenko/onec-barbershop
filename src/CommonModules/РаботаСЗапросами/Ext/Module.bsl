﻿Процедура ДобавитьВЗапросТекстУничтоженияВТ(Знач текстЗапроса, Знач имяВременнойТаблицы) Экспорт
	//Если Не ПустаяСтрока(ИмяВременнойТаблицы) И ЗапросСозданияВременнойТаблицы(ТекстЗапроса) Тогда
	//	ТекстЗапроса = ?(ПустаяСтрока(ТекстЗапроса), "", ТекстЗапроса + РазделительЗапросов()) + "УНИЧТОЖИТЬ " + ИмяВременнойТаблицы;
	//КонецЕсли;
КонецПроцедуры

Функция ЗапросУничтоженияВТ(Знач имяВременнойТаблицы) Экспорт
	текстЗапроса = " УНИЧТОЖИТЬ " + ИмяВременнойТаблицы; 
	Возврат Новый Запрос(ТекстЗапроса);
КонецФункции

Процедура СоздатьВТ(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудникиОрганизации = "ВТСотрудникиОрганизации") Экспорт
	
КонецПроцедуры