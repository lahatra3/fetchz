const std = @import("std");
const http = std.http;
const Client = http.Client;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const Fetchz = struct {
    const Self = @This();
    client: Client,
    response_body: ArrayList(u8),

    pub fn init(allocator: Allocator) Self {
        return Self{ 
            .allocator = allocator, 
            .client = Client{ 
                .allocator = allocator 
            }, 
            .response_body = ArrayList(u8).init(allocator)
        };
    }

    pub fn deinit(self: *Self) void {
        self.client.deinit();
        self.response_body.deinit();
    }

    pub fn get(self: *Self, url: []const u8, headers: []http.Header) !Client.FetchResult {
        const fetch_options = Client.FetchOptions{ 
            .location = .{ 
                .url = url 
            }, 
            .method = .GET, 
            .extra_headers = headers, 
            .response_storage = .{ 
                .dynamic = &self.response_body 
            } 
        };
        return try self.client.fetch(fetch_options);
    }
};
