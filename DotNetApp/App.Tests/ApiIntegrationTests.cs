using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace App.Tests;

public class ApiIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ApiIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetHealth_ReturnsOkAndHealthyStatus()
    {
        var response = await _client.GetAsync("/health");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("Healthy", body);
    }

    [Fact]
    public async Task GetRoot_ReturnsOk()
    {
        var response = await _client.GetAsync("/");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("API Service is running", body);
    }

    [Fact]
    public async Task PostUser_WithValidData_ReturnsCreated()
    {
        var user = new User
        {
            Name = "Test User",
            Login = "testuser",
            Password = "password123"
        };

        var response = await _client.PostAsJsonAsync("/users", user);

        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        var createdUser = await response.Content.ReadFromJsonAsync<User>();
        Assert.NotNull(createdUser);
        Assert.Equal("Test User", createdUser.Name);
    }

    [Fact]
    public async Task PostUser_WithEmptyData_ReturnsBadRequest()
    {
        var user = new User
        {
            Name = "",
            Login = ""
        };

        var response = await _client.PostAsJsonAsync("/users", user);

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }
}
