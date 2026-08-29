using Microsoft.EntityFrameworkCore;
using Xunit;

namespace App.Tests;

public class ModelAndDatabaseTests
{
    private AppDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        return new AppDbContext(options);
    }

    [Fact]
    public void UserModel_ShouldSetAndGetPropertiesCorrectly()
    {
        var user = new User
        {
            Id = 1,
            Name = "John Doe",
            Login = "johndoe",
            Password = "secretpassword"
        };

        Assert.Equal(1, user.Id);
        Assert.Equal("John Doe", user.Name);
        Assert.Equal("johndoe", user.Login);
        Assert.Equal("secretpassword", user.Password);
    }

    [Fact]
    public void ProductModel_ShouldSetAndGetPropertiesCorrectly()
    {
        var product = new Product
        {
            Id = 10,
            Name = "Laptop",
            Price = 999.99m,
            StockQuantity = 50
        };

        Assert.Equal(10, product.Id);
        Assert.Equal("Laptop", product.Name);
        Assert.Equal(999.99m, product.Price);
        Assert.Equal(50, product.StockQuantity);
    }

    [Fact]
    public async Task DbContext_CanAddAndRetrieveUser()
    {
        using var db = CreateInMemoryDbContext();
        var user = new User { Name = "Alice", Login = "alice", Password = "123" };

        db.Users.Add(user);
        await db.SaveChangesAsync();

        var retrievedUser = await db.Users.FirstOrDefaultAsync(u => u.Login == "alice");

        Assert.NotNull(retrievedUser);
        Assert.Equal("Alice", retrievedUser.Name);
    }

    [Fact]
    public async Task DbContext_CanAddAndRetrieveProduct()
    {
        using var db = CreateInMemoryDbContext();
        var product = new Product { Name = "Keyboard", Price = 49.99m, StockQuantity = 100 };

        db.Products.Add(product);
        await db.SaveChangesAsync();

        var retrievedProduct = await db.Products.FirstOrDefaultAsync(p => p.Name == "Keyboard");

        Assert.NotNull(retrievedProduct);
        Assert.Equal(49.99m, retrievedProduct.Price);
    }

    [Fact]
    public async Task DbContext_CanDeleteUser()
    {
        using var db = CreateInMemoryDbContext();
        var user = new User { Name = "Bob", Login = "bob", Password = "123" };
        db.Users.Add(user);
        await db.SaveChangesAsync();

        db.Users.Remove(user);
        await db.SaveChangesAsync();

        var retrievedUser = await db.Users.FindAsync(user.Id);

        Assert.Null(retrievedUser);
    }
}
