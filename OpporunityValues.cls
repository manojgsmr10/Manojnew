public class OpporunityValues 
{
    
    //Task 1: I want to find the order with the highest value for the day
    public static List<opportunity> calculcatehighestorder(){
        
        List<opportunity> lstopp=[select Id,Date_Time__c,amount,account.Name,account.AccountNumber from opportunity where Date_Time__c<>null  order by amount desc limit 1];
        system.debug('CustomerName>>>'+lstopp[0].account.Name);
         system.debug('valueofOrder>>>'+lstopp[0].amount);
        String formattedDate = lstopp[0].Date_Time__c.format('MMMM d, yyyy HH:mm');
         system.debug('DateofOrder>>>'+formattedDate);
        return  lstopp;
            
             
    }
    
    //Date inputDate = Date.newInstance(2024, 5,22); // Year, Month, Day, Hour, Minute, Second
   //OpporunityValues.calculcatemostduring(inputDate); // Year, Month, Day, Hour, Minute, Second

    //Task 2: I want to find the customer who spent the most during the day
    public static void calculcatemostduring(date mydate){
        AggregateResult[] groupedResults = [
            SELECT AccountId, Account.Name Name, count(Id) totalValue,sum(amount) totalorder
            FROM opportunity WHERE Date_Time__c<>null and DAY_ONLY(Date_Time__c)=:mydate GROUP BY AccountId, Account.Name];
        system.debug('groupedResults'+groupedResults);
        // Iterate through the grouped results and display the customer name and total order value
        String highestCustomerName = '';
        Decimal highestOrderValue = 0;
        decimal highesttotalorder=0;
        for (AggregateResult result : groupedResults) {
            String customerName = (String) result.get('Name');
            Decimal totalOrderValue = (Decimal) result.get('totalorder');
            Decimal totalorder=  (Decimal) result.get('totalValue');
            // Compare and track the highest order value
            if (totalorder > highesttotalorder) {
                highestOrderValue = totalOrderValue;
                highestCustomerName = customerName;
                highesttotalorder=totalorder;
            }
            // Output the result
            // System.debug('Customer: ' + highestCustomerName + ', Total Order Value: ' + highestOrderValue);
        }
        System.debug('Customer: ' + highestCustomerName + ', Total Order Value: ' + highestOrderValue);
    }
    
    //Task 4: calculate hours in days
    public static void calculcatebusinesshourds(datetime startOfDay,datetime endOfDay){
        system.debug('start'+startOfDay);
        system.debug('enddate'+endOfDay);
    
    // calcualte the Business hours for day
   // / Define the specific day you want to check (e.g., today)
    AggregateResult[] groupedResults = [
            SELECT HOUR_IN_DAY(convertTimezone(Opportunity.Date_time__c)) hourOfDay, SUM(Quantity) totalQuantity
            FROM OpportunityLineItem
            WHERE Opportunity.Date_time__c<>null and Opportunity.Date_time__c >= :startOfDay AND 
         Opportunity.Date_time__c <= :endOfDay
              GROUP BY HOUR_IN_DAY(convertTimezone(Opportunity.Date_time__c))   ORDER BY sum(Quantity) DESC  LIMIT 1];
          
           
      system.debug('group resut'+groupedResults);  
    
    // Output the hour with the most items ordered
    if (!groupedResults.isEmpty()) {
        AggregateResult result = groupedResults[0];
        Integer hourOfDay = (Integer) result.get('hourOfDay');
        Decimal totalQuantity = (Decimal) result.get('totalQuantity');
        
        System.debug('Hour with the most items ordered: ' + hourOfDay + ':00, Total Quantity: ' + totalQuantity);
    } 
        else {
        System.debug('No OpportunityLineItems found for today.');
    }
    }    
   

}