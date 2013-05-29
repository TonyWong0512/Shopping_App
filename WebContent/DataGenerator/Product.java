public class Product
{
    String name;
    int catId;
    int price;
    public Product(String nname, int ncatid, int nprice)
    {
        name = nname;
        catId = ncatid;
        price = nprice;
    }

    @Override
    public boolean equals(Object obj)
    {
        Product p = (Product) obj;
        return (obj != null && p.name.equals(name) && obj.getClass().equals(getClass()));
    }

    @Override
    public int hashCode() 
    {
        return name.hashCode();
    }
}
