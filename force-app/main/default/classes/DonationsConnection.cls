global class DonationsConnection extends DataSource.Connection {
     
    override global List<DataSource.Table> sync() {
        
        List<DataSource.Column> donationColumns = new List<DataSource.Column>();
        donationColumns.add(DataSource.Column.text('ExternalId', 50));
        donationColumns.add(DataSource.Column.url('DisplayUrl'));
        donationColumns.add(DataSource.Column.text('URN', 30));
        donationColumns.add(DataSource.Column.text('PersonId', 30));
        donationColumns.add(DataSource.Column.number('Amount', 16, 2));
        donationColumns.add(DataSource.Column.text('PayDate', 30));
        donationColumns.add(DataSource.Column.text('PayMethod', 30));
        donationColumns.add(DataSource.Column.text('Status', 30));
        donationColumns.add(DataSource.Column.text('ProdId', 30));
        donationColumns.add(DataSource.Column.text('EventId', 30));
        donationColumns.add(DataSource.Column.text('Source', 30));
         
        List<DataSource.Table> tables = new List<DataSource.Table>();
        tables.add(DataSource.Table.get('Donations', 'Name', donationColumns));
        
        return tables;
    }
     
    override global DataSource.TableResult query(DataSource.QueryContext queryContext) {
 
        String url = 'https://4ccffff04f40.ngrok.io/posts';
        List<Map<String, Object>> donations = DataSource.QueryUtils.process(queryContext, getDonations(url));
        DataSource.TableResult tableResult = DataSource.TableResult.get(queryContext, donations);
        
        return tableResult;
    }
     
    override global List<DataSource.TableResult> search(
            DataSource.SearchContext context) {
        List<DataSource.TableResult> results =
                new List<DataSource.TableResult>();
 
        for (Integer i =0;i< context.tableSelections.size();i++) {
            String entity = context.tableSelections[i].tableSelected;
 			system.debug(context.searchPhrase);
            String url = 'https://4ccffff04f40.ngrok.io/posts?'
                            + context.searchPhrase;
            results.add(DataSource.TableResult.get(
                    true, null, entity, getDonations(url)));
            
        }
 		system.debug(results);
                
        return results;
    }
     
    public List<Map<String, Object>> getDonations(String url) {
        
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
//        String url = 'https://run.mocky.io/v3/b1a7de37-4948-4490-8aac-8a8129cdb155';
        request.setEndPoint(url);
        request.setMethod('GET');
         system.debug(request);
        HttpResponse response = httpProtocol.send(request);
         system.debug(response);
         
        List<Map<String, Object>> donations = new List<Map<String, Object>>();
        Integer i = 1;
        for (Object item : (List<Object>)JSON.deserializeUntyped(response.getBody())) {
            Map<String, Object> donation = (Map<String, Object>)item;
            donation.put('ExternalId', donation.get('EXTERNAL_REF'));
            donation.put('DisplayUrl', url + '/' + i);
            donation.put('URN', donation.get('URN'));
            donation.put('Person', donation.get('PERSON_ID'));
            donation.put('Amount', donation.get('AMOUNT'));
            donation.put('PayDate', donation.get('PAY_DATE'));
            donation.put('PayMethod', donation.get('PAY_METHOD'));
            donation.put('Status', donation.get('STATUS'));
            donation.put('ProductId', donation.get('PROD_ID'));
            donation.put('EventId', donation.get('EVENT_ID'));
            donation.put('Source', donation.get('SOURCE'));
            donations.add(donation);
            i++;
//            system.debug(donation);
        }
        
        return donations;
    }
 //test comment2    
}