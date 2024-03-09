﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(_, __)
    выполнитьВсеДвижения();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

#Область Движения
Процедура выполнитьВсеДвижения()
    Движения.Начисления.Записывать = Истина;

    выполнитьДвиженияПоВсемНачислениям();
    Движения.Начисления.Записать();
    Движения.Начисления.РассчитатьСуммуНачисления();
КонецПроцедуры

Процедура выполнитьДвиженияПоВсемНачислениям()
    Для Каждого строкаНачисления Из ЭтотОбъект.Начисления Цикл
        структураНачисления = РегистрыРасчета.Начисления.СоздатьПустуюСтруктуруНачисления();

        ЗаполнитьЗначенияСвойств(структураНачисления, строкаНачисления);
        структураНачисления.ДатаНачала = НачалоМесяца(ЭтотОбъект.ПериодНачисления);
        структураНачисления.ДатаОкончания = КонецМесяца(ЭтотОбъект.ПериодНачисления);

        РегистрыРасчета.Начисления.ЗаполнитьДвижениеНачисления(
            Движения.Начисления.Добавить(), ЭтотОбъект.ПериодНачисления, структураНачисления);
    КонецЦикла;
КонецПроцедуры
#КонецОбласти // Движения

#КонецОбласти // СлужебныеПроцедурыИФункции
